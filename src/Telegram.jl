module Telegram

using HTTP
using JSON
using ScopedValues
using Logging

include("client.jl")
include("types.jl")
include("methods.jl")
include("streaming.jl")
include("webhook.jl")

end # module Telegram
