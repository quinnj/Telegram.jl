using Test, Telegram

const TOKEN = get(ENV, "TELEGRAM_BOT_TOKEN", "")

@testset "Text splitting" begin
    @test Telegram.split_message_text("") == String[]
    @test Telegram.split_message_text("short"; limit=10) == ["short"]
    @test Telegram.split_message_text("a b c"; limit=3) == ["a ", "b ", "c"]
    @test Telegram.split_message_text("a\nb\nc"; limit=3) == ["a\n", "b\n", "c"]
    @test Telegram.split_message_text("abcdefgh"; limit=3) == ["abc", "def", "gh"]
end

@testset "Telegram" begin
    if isempty(TOKEN)
        @warn "Set TELEGRAM_BOT_TOKEN to run live tests"
        return
    end

    Telegram.with_telegram(TOKEN) do
        @testset "Bot info" begin
            me = Telegram.get_me()
            @test me isa Telegram.User
            @test me.is_bot == true
            @test me.first_name isa String
        end

        @testset "Webhook info" begin
            info = Telegram.get_webhook_info()
            @test info isa Telegram.WebhookInfo
            @test info.pending_update_count isa Int64
        end

        @testset "Commands" begin
            cmds = Telegram.get_my_commands()
            @test cmds isa Vector{Telegram.BotCommand}
        end

        @testset "Bot name & description" begin
            name = Telegram.get_my_name()
            @test name isa Telegram.BotName

            desc = Telegram.get_my_description()
            @test desc isa Telegram.BotDescription

            sdesc = Telegram.get_my_short_description()
            @test sdesc isa Telegram.BotShortDescription
        end

        @testset "Error handling" begin
            @test_throws Telegram.TelegramError Telegram.get_chat("nonexistent")
            try
                Telegram.get_chat("nonexistent")
            catch e
                @test e isa Telegram.TelegramError
                @test e.error_code == 400
            end
        end

        @testset "Get updates" begin
            updates = Telegram.get_updates(; timeout=1)
            @test updates isa Vector{Telegram.Update}
        end
    end
end
