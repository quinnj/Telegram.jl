# ============================================================================
# Webhook & Long-Polling Servers
# ============================================================================

"""
    run_polling(handler; timeout=30, allowed_updates=nothing, error_handler=nothing)

Start a long-polling loop that fetches updates and calls `handler(update::Update)`
for each one. Blocks indefinitely.

`error_handler(exception, backtrace)` is called if `handler` throws; defaults to
logging with `@error`.

# Example
```julia
with_telegram("TOKEN") do
    run_polling() do update
        msg = update.message
        msg === nothing && return
        send_message(msg.chat.id, "Echo: \$(msg.text)")
    end
end
```
"""
function run_polling(handler::Function;
        timeout::Int = 30,
        allowed_updates::Union{Vector{String},Nothing} = nothing,
        error_handler::Union{Function,Nothing} = nothing)
    @info "Telegram.run_polling: Starting polling loop" timeout=timeout allowed_updates=allowed_updates
    offset = 0
    consecutive_errors = 0
    while true
        local updates
        try
            @debug "Telegram.run_polling: Fetching updates" offset=offset timeout=timeout
            updates = get_updates(; offset, timeout, allowed_updates)
            consecutive_errors = 0  # Reset on success
            if !isempty(updates)
                @info "Telegram.run_polling: Received $(length(updates)) update(s)" offset=offset
            end
        catch e
            consecutive_errors += 1
            backoff = min(60, 2^min(consecutive_errors, 6))  # 2, 4, 8, 16, 32, 60, 60...
            if e isa TelegramError
                @error "Polling: API error (retry in $(backoff)s)" error_code=e.error_code description=e.description
            else
                @error "Polling: network error (retry in $(backoff)s)" exception=(e, catch_backtrace())
            end
            sleep(backoff)
            continue
        end
        for update in updates
            try
                handler(update)
            catch e
                bt = catch_backtrace()
                if error_handler !== nothing
                    error_handler(e, bt)
                else
                    @error "Polling handler error" exception=(e, bt)
                end
            end
            offset = update.update_id + 1
        end
    end
end

"""
    run_webhook(handler; host="0.0.0.0", port=8080, path="/webhook", secret_token=nothing)

Start an HTTP server that receives Telegram webhook updates and calls
`handler(update::Update)` for each one. Blocks until the server is stopped.

If `secret_token` is provided, the server verifies the
`X-Telegram-Bot-Api-Secret-Token` header on each request.

# Example
```julia
with_telegram("TOKEN") do
    # First, tell Telegram where to send updates
    set_webhook("https://example.com/webhook"; secret_token="mysecret")

    run_webhook(; secret_token="mysecret") do update
        msg = update.message
        msg === nothing && return
        send_message(msg.chat.id, "Echo: \$(msg.text)")
    end
end
```
"""
function run_webhook(handler::Function;
        host::String = "0.0.0.0",
        port::Int = 8080,
        path::String = "/webhook",
        secret_token::Union{String,Nothing} = nothing,
        error_handler::Union{Function,Nothing} = nothing)
    HTTP.serve(host, port) do req::HTTP.Request
        # Only accept POST to our webhook path
        if req.method != "POST" || req.target != path
            return HTTP.Response(404, "Not Found")
        end
        # Verify secret token if configured
        if secret_token !== nothing
            header_token = HTTP.header(req, "X-Telegram-Bot-Api-Secret-Token", "")
            if header_token != secret_token
                return HTTP.Response(403, "Forbidden")
            end
        end
        # Parse and dispatch the update
        try
            update = JSON.parse(String(req.body), Update)
            try
                handler(update)
            catch e
                bt = catch_backtrace()
                if error_handler !== nothing
                    error_handler(e, bt)
                else
                    @error "Webhook handler error" exception=(e, bt)
                end
            end
        catch e
            @error "Webhook parse error" exception=(e, catch_backtrace())
        end
        return HTTP.Response(200, "OK")
    end
end
