# ============================================================================
# Telegram Bot API Client Infrastructure
# ============================================================================

const API_BASE_URL = "https://api.telegram.org/bot"

# --- Error type ---

struct TelegramError <: Exception
    error_code::Int
    description::String
end

Base.showerror(io::IO, e::TelegramError) =
    print(io, "TelegramError($(e.error_code)): $(e.description)")

# --- Client ---

struct Client
    token::String
    base_url::String
end

const TELEGRAM_CLIENT = ScopedValue{Client}()

"""
    with_telegram(f::Function, token::String; base_url::String = API_BASE_URL)

Execute `f` with a scoped Telegram bot client.

# Example
```julia
with_telegram("YOUR_BOT_TOKEN") do
    me = get_me()
    println("Bot: \$(me.first_name)")
end
```
"""
function with_telegram(f::Function, token::String; base_url::String = API_BASE_URL)
    client = Client(token, string(base_url, token, "/"))
    @with TELEGRAM_CLIENT => client f()
end

"""
    with_client(f::Function, client::Client)

Execute `f` with an existing `Client` bound as the active Telegram client.
Useful for re-establishing the client context in spawned tasks.
"""
with_client(f::Function, client::Client) = @with TELEGRAM_CLIENT => client f()

function _get_client()
    isassigned(TELEGRAM_CLIENT) || error("No Telegram client set. Use `with_telegram(token)` to set credentials.")
    return TELEGRAM_CLIENT[]
end

# --- Request helpers ---

function _build_params(; kwargs...)
    params = Dict{String,Any}()
    for (k, v) in kwargs
        v !== nothing && (params[String(k)] = v)
    end
    return params
end

# Parse the "result" field into the expected Julia type
_parse_result(::Type{Bool}, result) = result::Bool
_parse_result(::Type{Int64}, result) = Int64(result)
_parse_result(::Type{String}, result) = String(result)
_parse_result(::Type{Any}, result) = result
_parse_result(::Type{Vector{T}}, result) where T = T[_parse_result(T, x) for x in result]
function _parse_result(::Type{T}, result) where T
    JSON.parse(JSON.json(result), T)
end

"""
    _make_request(::Type{T}, method_name; kwargs...) -> T

Call a Telegram Bot API method with JSON body and parse the typed response.
"""
function _make_request(::Type{T}, method_name::String; kwargs...) where T
    client = _get_client()
    url = string(client.base_url, method_name)
    params = _build_params(; kwargs...)
    headers = ["Content-Type" => "application/json"]
    resp = HTTP.post(url, headers;
        body = JSON.json(params; omit_null=true),
        status_exception = false
    )
    data = JSON.parse(String(resp.body))
    if !data["ok"]
        throw(TelegramError(
            get(data, "error_code", resp.status),
            get(data, "description", "Unknown error")
        ))
    end
    _parse_result(T, data["result"])
end

# Serialize a value for multipart form fields
_serialize_param(v::AbstractString) = v
_serialize_param(v::Number) = string(v)
_serialize_param(v::Bool) = string(v)
_serialize_param(v) = JSON.json(v; omit_null=true)

"""
    _make_multipart_request(::Type{T}, method_name, file_fields; kwargs...) -> T

Call a Telegram Bot API method with multipart/form-data for file uploads.
`file_fields` maps field names to `(filename, data::Vector{UInt8}, content_type)` tuples.
"""
function _make_multipart_request(::Type{T}, method_name::String,
        file_fields::Dict{String}; kwargs...) where T
    client = _get_client()
    url = string(client.base_url, method_name)
    parts = Pair{String,Any}[]
    for (field, (filename, data, content_type)) in file_fields
        push!(parts, field => HTTP.Multipart(filename, IOBuffer(data), content_type))
    end
    for (k, v) in kwargs
        v !== nothing && push!(parts, String(k) => _serialize_param(v))
    end
    resp = HTTP.post(url, [], HTTP.Form(parts); status_exception = false)
    data = JSON.parse(String(resp.body))
    if !data["ok"]
        throw(TelegramError(
            get(data, "error_code", resp.status),
            get(data, "description", "Unknown error")
        ))
    end
    _parse_result(T, data["result"])
end
