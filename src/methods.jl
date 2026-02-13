# ============================================================================
# Telegram Bot API Methods
# https://core.telegram.org/bots/api#available-methods
# ============================================================================

# ===== Limits & helpers =====================================================

const MAX_MESSAGE_TEXT_LENGTH = 4096

"""
    split_message_text(text; limit=MAX_MESSAGE_TEXT_LENGTH) -> Vector{String}

Split `text` into chunks no longer than `limit` characters.

Prefers splitting on newline boundaries, then whitespace, and falls back
to a hard cut when no boundary is found within the limit.

Note: Telegram's limit is enforced after entity parsing. For Markdown/HTML,
this helper is best-effort and may split inside formatting.
"""
function split_message_text(text::AbstractString; limit::Int = MAX_MESSAGE_TEXT_LENGTH)
    limit >= 1 || throw(ArgumentError("limit must be >= 1"))
    isempty(text) && return String[]

    parts = String[]
    start = firstindex(text)
    last = lastindex(text)
    while start <= last
        stop = nextind(text, start, limit - 1)
        if stop > last
            push!(parts, String(text[start:last]))
            break
        end

        sub = SubString(text, start, stop)
        br = findlast(==('\n'), sub)
        br === nothing && (br = findlast(isspace, sub))
        (br === nothing || br == start) && (br = stop)

        push!(parts, String(text[start:br]))
        start = nextind(text, br)
    end
    return parts
end

"""
    send_long_message(chat_id, text; limit=MAX_MESSAGE_TEXT_LENGTH, kwargs...) -> Vector{Message}

Send `text` split into multiple messages if it exceeds Telegram's length limit.
Returns a vector of `Message`s, one per chunk.
"""
function send_long_message(chat_id::Union{Int64,String}, text::String;
        limit::Int = MAX_MESSAGE_TEXT_LENGTH, kwargs...)
    parts = split_message_text(text; limit)
    msgs = Message[]
    for part in parts
        push!(msgs, send_message(chat_id, part; kwargs...))
    end
    return msgs
end

# ===== Getting updates ======================================================

function get_updates(; offset=nothing, limit=nothing, timeout=nothing, allowed_updates=nothing)
    client = _get_client()
    url = string(client.base_url, "getUpdates")
    params = _build_params(; offset, limit, timeout, allowed_updates)
    headers = ["Content-Type" => "application/json"]
    # Client-side readtimeout must exceed the server-side long-poll timeout
    # to avoid killing the connection while Telegram is still holding it.
    read_timeout = timeout === nothing ? 60 : timeout + 15
    resp = HTTP.post(url, headers;
        body = JSON.json(params; omit_null=true),
        status_exception = false,
        readtimeout = read_timeout,
    )
    data = JSON.parse(String(resp.body))
    if !data["ok"]
        throw(TelegramError(
            get(data, "error_code", resp.status),
            get(data, "description", "Unknown error")
        ))
    end
    _parse_result(Vector{Update}, data["result"])
end

function set_webhook(url::String; certificate=nothing, ip_address=nothing,
        max_connections=nothing, allowed_updates=nothing,
        drop_pending_updates=nothing, secret_token=nothing)
    _make_request(Bool, "setWebhook"; url, certificate, ip_address,
        max_connections, allowed_updates, drop_pending_updates, secret_token)
end

delete_webhook(; drop_pending_updates=nothing) =
    _make_request(Bool, "deleteWebhook"; drop_pending_updates)

get_webhook_info() = _make_request(WebhookInfo, "getWebhookInfo")

# ===== Bot info =============================================================

get_me() = _make_request(User, "getMe")

log_out() = _make_request(Bool, "logOut")

close_bot() = _make_request(Bool, "close")

# ===== Sending messages =====================================================

function send_message(chat_id::Union{Int64,String}, text::String;
        parse_mode=nothing, entities=nothing, link_preview_options=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing, allow_paid_broadcast=nothing)
    _make_request(Message, "sendMessage"; chat_id, text,
        parse_mode, entities, link_preview_options,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id, allow_paid_broadcast)
end

function forward_message(chat_id::Union{Int64,String}, from_chat_id::Union{Int64,String},
        message_id::Int64; message_thread_id=nothing, disable_notification=nothing,
        protect_content=nothing)
    _make_request(Message, "forwardMessage"; chat_id, from_chat_id, message_id,
        message_thread_id, disable_notification, protect_content)
end

function forward_messages(chat_id::Union{Int64,String}, from_chat_id::Union{Int64,String},
        message_ids::Vector{Int64}; message_thread_id=nothing,
        disable_notification=nothing, protect_content=nothing)
    _make_request(Vector{MessageId}, "forwardMessages"; chat_id, from_chat_id,
        message_ids, message_thread_id, disable_notification, protect_content)
end

function copy_message(chat_id::Union{Int64,String}, from_chat_id::Union{Int64,String},
        message_id::Int64; message_thread_id=nothing, caption=nothing,
        parse_mode=nothing, caption_entities=nothing,
        show_caption_above_media=nothing, disable_notification=nothing,
        protect_content=nothing, reply_parameters=nothing, reply_markup=nothing)
    _make_request(MessageId, "copyMessage"; chat_id, from_chat_id, message_id,
        message_thread_id, caption, parse_mode, caption_entities,
        show_caption_above_media, disable_notification, protect_content,
        reply_parameters, reply_markup)
end

function copy_messages(chat_id::Union{Int64,String}, from_chat_id::Union{Int64,String},
        message_ids::Vector{Int64}; message_thread_id=nothing,
        disable_notification=nothing, protect_content=nothing)
    _make_request(Vector{MessageId}, "copyMessages"; chat_id, from_chat_id,
        message_ids, message_thread_id, disable_notification, protect_content)
end

function send_photo(chat_id::Union{Int64,String}, photo::String;
        caption=nothing, parse_mode=nothing, caption_entities=nothing,
        show_caption_above_media=nothing, has_spoiler=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendPhoto"; chat_id, photo,
        caption, parse_mode, caption_entities, show_caption_above_media,
        has_spoiler, reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_photo(chat_id::Union{Int64,String}, photo::InputFile; kwargs...)
    _make_multipart_request(Message, "sendPhoto",
        Dict("photo" => (photo.filename, photo.data, photo.content_type));
        chat_id, kwargs...)
end

function send_audio(chat_id::Union{Int64,String}, audio::String;
        caption=nothing, parse_mode=nothing, caption_entities=nothing,
        duration=nothing, performer=nothing, title=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendAudio"; chat_id, audio,
        caption, parse_mode, caption_entities, duration, performer, title,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_document(chat_id::Union{Int64,String}, document::String;
        caption=nothing, parse_mode=nothing, caption_entities=nothing,
        disable_content_type_detection=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendDocument"; chat_id, document,
        caption, parse_mode, caption_entities, disable_content_type_detection,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_video(chat_id::Union{Int64,String}, video::String;
        duration=nothing, width=nothing, height=nothing,
        caption=nothing, parse_mode=nothing, caption_entities=nothing,
        show_caption_above_media=nothing, has_spoiler=nothing,
        supports_streaming=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendVideo"; chat_id, video,
        duration, width, height, caption, parse_mode, caption_entities,
        show_caption_above_media, has_spoiler, supports_streaming,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_animation(chat_id::Union{Int64,String}, animation::String;
        duration=nothing, width=nothing, height=nothing,
        caption=nothing, parse_mode=nothing, caption_entities=nothing,
        show_caption_above_media=nothing, has_spoiler=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendAnimation"; chat_id, animation,
        duration, width, height, caption, parse_mode, caption_entities,
        show_caption_above_media, has_spoiler,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_voice(chat_id::Union{Int64,String}, voice::String;
        caption=nothing, parse_mode=nothing, caption_entities=nothing,
        duration=nothing, reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendVoice"; chat_id, voice,
        caption, parse_mode, caption_entities, duration,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_video_note(chat_id::Union{Int64,String}, video_note::String;
        duration=nothing, length=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendVideoNote"; chat_id, video_note,
        duration, length, reply_parameters, reply_markup,
        message_thread_id, business_connection_id,
        disable_notification, protect_content, message_effect_id)
end

function send_media_group(chat_id::Union{Int64,String}, media::Vector;
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing)
    _make_request(Vector{Message}, "sendMediaGroup"; chat_id, media,
        message_thread_id, business_connection_id,
        disable_notification, protect_content)
end

function send_location(chat_id::Union{Int64,String}, latitude::Float64, longitude::Float64;
        horizontal_accuracy=nothing, live_period=nothing,
        heading=nothing, proximity_alert_radius=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendLocation"; chat_id, latitude, longitude,
        horizontal_accuracy, live_period, heading, proximity_alert_radius,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_venue(chat_id::Union{Int64,String}, latitude::Float64, longitude::Float64,
        title::String, address::String;
        foursquare_id=nothing, foursquare_type=nothing,
        google_place_id=nothing, google_place_type=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendVenue"; chat_id, latitude, longitude, title, address,
        foursquare_id, foursquare_type, google_place_id, google_place_type,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_contact(chat_id::Union{Int64,String}, phone_number::String, first_name::String;
        last_name=nothing, vcard=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendContact"; chat_id, phone_number, first_name,
        last_name, vcard, reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_poll(chat_id::Union{Int64,String}, question::String, options::Vector;
        is_anonymous=nothing, type=nothing, allows_multiple_answers=nothing,
        correct_option_id=nothing, explanation=nothing,
        explanation_parse_mode=nothing, explanation_entities=nothing,
        open_period=nothing, close_date=nothing, is_closed=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendPoll"; chat_id, question, options,
        is_anonymous, type, allows_multiple_answers, correct_option_id,
        explanation, explanation_parse_mode, explanation_entities,
        open_period, close_date, is_closed,
        reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_dice(chat_id::Union{Int64,String};
        emoji=nothing, reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendDice"; chat_id,
        emoji, reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

function send_chat_action(chat_id::Union{Int64,String}, action::String;
        message_thread_id=nothing, business_connection_id=nothing)
    _make_request(Bool, "sendChatAction"; chat_id, action,
        message_thread_id, business_connection_id)
end

function send_sticker(chat_id::Union{Int64,String}, sticker::String;
        emoji=nothing, reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing,
        disable_notification=nothing, protect_content=nothing,
        message_effect_id=nothing)
    _make_request(Message, "sendSticker"; chat_id, sticker,
        emoji, reply_parameters, reply_markup, message_thread_id,
        business_connection_id, disable_notification, protect_content,
        message_effect_id)
end

# ===== Reactions ============================================================

function set_message_reaction(chat_id::Union{Int64,String}, message_id::Int64;
        reaction=nothing, is_big=nothing)
    _make_request(Bool, "setMessageReaction"; chat_id, message_id, reaction, is_big)
end

# ===== User & file info =====================================================

function get_user_profile_photos(user_id::Int64; offset=nothing, limit=nothing)
    _make_request(UserProfilePhotos, "getUserProfilePhotos"; user_id, offset, limit)
end

get_file(file_id::String) = _make_request(TelegramFile, "getFile"; file_id)

"""
    get_file_url(file::TelegramFile) -> String

Build the download URL for a file returned by `get_file`.
"""
function get_file_url(file::TelegramFile)
    client = _get_client()
    "https://api.telegram.org/file/bot$(client.token)/$(file.file_path)"
end

"""
    download_file(file::TelegramFile) -> Vector{UInt8}

Download a file's contents from Telegram servers.
"""
function download_file(file::TelegramFile)
    url = get_file_url(file)
    resp = HTTP.get(url)
    resp.body
end

# ===== Chat member management ===============================================

function ban_chat_member(chat_id::Union{Int64,String}, user_id::Int64;
        until_date=nothing, revoke_messages=nothing)
    _make_request(Bool, "banChatMember"; chat_id, user_id, until_date, revoke_messages)
end

function unban_chat_member(chat_id::Union{Int64,String}, user_id::Int64;
        only_if_banned=nothing)
    _make_request(Bool, "unbanChatMember"; chat_id, user_id, only_if_banned)
end

function restrict_chat_member(chat_id::Union{Int64,String}, user_id::Int64,
        permissions::ChatPermissions; use_independent_chat_permissions=nothing,
        until_date=nothing)
    _make_request(Bool, "restrictChatMember"; chat_id, user_id, permissions,
        use_independent_chat_permissions, until_date)
end

function promote_chat_member(chat_id::Union{Int64,String}, user_id::Int64;
        is_anonymous=nothing, can_manage_chat=nothing,
        can_delete_messages=nothing, can_manage_video_chats=nothing,
        can_restrict_members=nothing, can_promote_members=nothing,
        can_change_info=nothing, can_invite_users=nothing,
        can_post_stories=nothing, can_edit_stories=nothing,
        can_delete_stories=nothing, can_post_messages=nothing,
        can_edit_messages=nothing, can_pin_messages=nothing,
        can_manage_topics=nothing)
    _make_request(Bool, "promoteChatMember"; chat_id, user_id,
        is_anonymous, can_manage_chat, can_delete_messages,
        can_manage_video_chats, can_restrict_members, can_promote_members,
        can_change_info, can_invite_users, can_post_stories,
        can_edit_stories, can_delete_stories, can_post_messages,
        can_edit_messages, can_pin_messages, can_manage_topics)
end

function set_chat_administrator_custom_title(chat_id::Union{Int64,String},
        user_id::Int64, custom_title::String)
    _make_request(Bool, "setChatAdministratorCustomTitle"; chat_id, user_id, custom_title)
end

function ban_chat_sender_chat(chat_id::Union{Int64,String}, sender_chat_id::Int64)
    _make_request(Bool, "banChatSenderChat"; chat_id, sender_chat_id)
end

function unban_chat_sender_chat(chat_id::Union{Int64,String}, sender_chat_id::Int64)
    _make_request(Bool, "unbanChatSenderChat"; chat_id, sender_chat_id)
end

# ===== Chat settings ========================================================

function set_chat_permissions(chat_id::Union{Int64,String}, permissions::ChatPermissions;
        use_independent_chat_permissions=nothing)
    _make_request(Bool, "setChatPermissions"; chat_id, permissions,
        use_independent_chat_permissions)
end

export_chat_invite_link(chat_id::Union{Int64,String}) =
    _make_request(String, "exportChatInviteLink"; chat_id)

function create_chat_invite_link(chat_id::Union{Int64,String};
        name=nothing, expire_date=nothing, member_limit=nothing,
        creates_join_request=nothing)
    _make_request(ChatInviteLink, "createChatInviteLink"; chat_id,
        name, expire_date, member_limit, creates_join_request)
end

function edit_chat_invite_link(chat_id::Union{Int64,String}, invite_link::String;
        name=nothing, expire_date=nothing, member_limit=nothing,
        creates_join_request=nothing)
    _make_request(ChatInviteLink, "editChatInviteLink"; chat_id, invite_link,
        name, expire_date, member_limit, creates_join_request)
end

function create_chat_subscription_invite_link(chat_id::Union{Int64,String},
        subscription_period::Int64, subscription_price::Int64; name=nothing)
    _make_request(ChatInviteLink, "createChatSubscriptionInviteLink"; chat_id,
        subscription_period, subscription_price, name)
end

function edit_chat_subscription_invite_link(chat_id::Union{Int64,String},
        invite_link::String; name=nothing)
    _make_request(ChatInviteLink, "editChatSubscriptionInviteLink"; chat_id,
        invite_link, name)
end

function revoke_chat_invite_link(chat_id::Union{Int64,String}, invite_link::String)
    _make_request(ChatInviteLink, "revokeChatInviteLink"; chat_id, invite_link)
end

function approve_chat_join_request(chat_id::Union{Int64,String}, user_id::Int64)
    _make_request(Bool, "approveChatJoinRequest"; chat_id, user_id)
end

function decline_chat_join_request(chat_id::Union{Int64,String}, user_id::Int64)
    _make_request(Bool, "declineChatJoinRequest"; chat_id, user_id)
end

function set_chat_photo(chat_id::Union{Int64,String}, photo::InputFile)
    _make_multipart_request(Bool, "setChatPhoto",
        Dict("photo" => (photo.filename, photo.data, photo.content_type));
        chat_id)
end

delete_chat_photo(chat_id::Union{Int64,String}) =
    _make_request(Bool, "deleteChatPhoto"; chat_id)

function set_chat_title(chat_id::Union{Int64,String}, title::String)
    _make_request(Bool, "setChatTitle"; chat_id, title)
end

function set_chat_description(chat_id::Union{Int64,String}; description=nothing)
    _make_request(Bool, "setChatDescription"; chat_id, description)
end

function pin_chat_message(chat_id::Union{Int64,String}, message_id::Int64;
        disable_notification=nothing, business_connection_id=nothing)
    _make_request(Bool, "pinChatMessage"; chat_id, message_id,
        disable_notification, business_connection_id)
end

function unpin_chat_message(chat_id::Union{Int64,String}; message_id=nothing,
        business_connection_id=nothing)
    _make_request(Bool, "unpinChatMessage"; chat_id, message_id,
        business_connection_id)
end

function unpin_all_chat_messages(chat_id::Union{Int64,String})
    _make_request(Bool, "unpinAllChatMessages"; chat_id)
end

leave_chat(chat_id::Union{Int64,String}) =
    _make_request(Bool, "leaveChat"; chat_id)

# ===== Chat info ============================================================

get_chat(chat_id::Union{Int64,String}) =
    _make_request(ChatFullInfo, "getChat"; chat_id)

get_chat_administrators(chat_id::Union{Int64,String}) =
    _make_request(Vector{ChatMember}, "getChatAdministrators"; chat_id)

get_chat_member_count(chat_id::Union{Int64,String}) =
    _make_request(Int64, "getChatMemberCount"; chat_id)

function get_chat_member(chat_id::Union{Int64,String}, user_id::Int64)
    _make_request(ChatMember, "getChatMember"; chat_id, user_id)
end

function set_chat_sticker_set(chat_id::Union{Int64,String}, sticker_set_name::String)
    _make_request(Bool, "setChatStickerSet"; chat_id, sticker_set_name)
end

delete_chat_sticker_set(chat_id::Union{Int64,String}) =
    _make_request(Bool, "deleteChatStickerSet"; chat_id)

# ===== Callback queries =====================================================

function answer_callback_query(callback_query_id::String;
        text=nothing, show_alert=nothing, url=nothing, cache_time=nothing)
    _make_request(Bool, "answerCallbackQuery"; callback_query_id,
        text, show_alert, url, cache_time)
end

# ===== User boosts ==========================================================

function get_user_chat_boosts(chat_id::Union{Int64,String}, user_id::Int64)
    _make_request(UserChatBoosts, "getUserChatBoosts"; chat_id, user_id)
end

get_business_connection(business_connection_id::String) =
    _make_request(BusinessConnection, "getBusinessConnection"; business_connection_id)

# ===== Bot commands =========================================================

function set_my_commands(commands::Vector{BotCommand};
        scope=nothing, language_code=nothing)
    _make_request(Bool, "setMyCommands"; commands, scope, language_code)
end

function delete_my_commands(; scope=nothing, language_code=nothing)
    _make_request(Bool, "deleteMyCommands"; scope, language_code)
end

function get_my_commands(; scope=nothing, language_code=nothing)
    _make_request(Vector{BotCommand}, "getMyCommands"; scope, language_code)
end

# ===== Bot name & description ===============================================

function set_my_name(; name=nothing, language_code=nothing)
    _make_request(Bool, "setMyName"; name, language_code)
end

get_my_name(; language_code=nothing) =
    _make_request(BotName, "getMyName"; language_code)

function set_my_description(; description=nothing, language_code=nothing)
    _make_request(Bool, "setMyDescription"; description, language_code)
end

get_my_description(; language_code=nothing) =
    _make_request(BotDescription, "getMyDescription"; language_code)

function set_my_short_description(; short_description=nothing, language_code=nothing)
    _make_request(Bool, "setMyShortDescription"; short_description, language_code)
end

get_my_short_description(; language_code=nothing) =
    _make_request(BotShortDescription, "getMyShortDescription"; language_code)

# ===== Menu button ==========================================================

function set_chat_menu_button(; chat_id=nothing, menu_button=nothing)
    _make_request(Bool, "setChatMenuButton"; chat_id, menu_button)
end

get_chat_menu_button(; chat_id=nothing) =
    _make_request(MenuButton, "getChatMenuButton"; chat_id)

function set_my_default_administrator_rights(; rights=nothing, for_channels=nothing)
    _make_request(Bool, "setMyDefaultAdministratorRights"; rights, for_channels)
end

get_my_default_administrator_rights(; for_channels=nothing) =
    _make_request(ChatAdministratorRights, "getMyDefaultAdministratorRights"; for_channels)

# ===== Editing messages =====================================================

function edit_message_text(text::String; chat_id=nothing, message_id=nothing,
        inline_message_id=nothing, parse_mode=nothing, entities=nothing,
        link_preview_options=nothing, reply_markup=nothing,
        business_connection_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "editMessageText"; text, chat_id, message_id,
        inline_message_id, parse_mode, entities, link_preview_options,
        reply_markup, business_connection_id)
end

# Convenience: edit by chat_id + message_id
function edit_message_text(chat_id::Union{Int64,String}, text::String;
        message_id::Int64, kwargs...)
    edit_message_text(text; chat_id, message_id, kwargs...)
end

function edit_message_caption(; chat_id=nothing, message_id=nothing,
        inline_message_id=nothing, caption=nothing, parse_mode=nothing,
        caption_entities=nothing, show_caption_above_media=nothing,
        reply_markup=nothing, business_connection_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "editMessageCaption"; chat_id, message_id,
        inline_message_id, caption, parse_mode, caption_entities,
        show_caption_above_media, reply_markup, business_connection_id)
end

function edit_message_media(media; chat_id=nothing, message_id=nothing,
        inline_message_id=nothing, reply_markup=nothing,
        business_connection_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "editMessageMedia"; media, chat_id, message_id,
        inline_message_id, reply_markup, business_connection_id)
end

function edit_message_live_location(latitude::Float64, longitude::Float64;
        chat_id=nothing, message_id=nothing, inline_message_id=nothing,
        horizontal_accuracy=nothing, heading=nothing,
        proximity_alert_radius=nothing, reply_markup=nothing,
        business_connection_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "editMessageLiveLocation"; latitude, longitude,
        chat_id, message_id, inline_message_id,
        horizontal_accuracy, heading, proximity_alert_radius,
        reply_markup, business_connection_id)
end

function stop_message_live_location(; chat_id=nothing, message_id=nothing,
        inline_message_id=nothing, reply_markup=nothing,
        business_connection_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "stopMessageLiveLocation"; chat_id, message_id,
        inline_message_id, reply_markup, business_connection_id)
end

function edit_message_reply_markup(; chat_id=nothing, message_id=nothing,
        inline_message_id=nothing, reply_markup=nothing,
        business_connection_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "editMessageReplyMarkup"; chat_id, message_id,
        inline_message_id, reply_markup, business_connection_id)
end

function stop_poll(chat_id::Union{Int64,String}, message_id::Int64;
        reply_markup=nothing, business_connection_id=nothing)
    _make_request(Poll, "stopPoll"; chat_id, message_id,
        reply_markup, business_connection_id)
end

function delete_message(chat_id::Union{Int64,String}, message_id::Int64)
    _make_request(Bool, "deleteMessage"; chat_id, message_id)
end

function delete_messages(chat_id::Union{Int64,String}, message_ids::Vector{Int64})
    _make_request(Bool, "deleteMessages"; chat_id, message_ids)
end

# ===== Forum topics =========================================================

get_forum_topic_icon_stickers() =
    _make_request(Vector{Sticker}, "getForumTopicIconStickers")

function create_forum_topic(chat_id::Union{Int64,String}, name::String;
        icon_color=nothing, icon_custom_emoji_id=nothing)
    _make_request(ForumTopic, "createForumTopic"; chat_id, name,
        icon_color, icon_custom_emoji_id)
end

function edit_forum_topic(chat_id::Union{Int64,String}, message_thread_id::Int64;
        name=nothing, icon_custom_emoji_id=nothing)
    _make_request(Bool, "editForumTopic"; chat_id, message_thread_id,
        name, icon_custom_emoji_id)
end

function close_forum_topic(chat_id::Union{Int64,String}, message_thread_id::Int64)
    _make_request(Bool, "closeForumTopic"; chat_id, message_thread_id)
end

function reopen_forum_topic(chat_id::Union{Int64,String}, message_thread_id::Int64)
    _make_request(Bool, "reopenForumTopic"; chat_id, message_thread_id)
end

function delete_forum_topic(chat_id::Union{Int64,String}, message_thread_id::Int64)
    _make_request(Bool, "deleteForumTopic"; chat_id, message_thread_id)
end

function unpin_all_forum_topic_messages(chat_id::Union{Int64,String},
        message_thread_id::Int64)
    _make_request(Bool, "unpinAllForumTopicMessages"; chat_id, message_thread_id)
end

function edit_general_forum_topic(chat_id::Union{Int64,String}, name::String)
    _make_request(Bool, "editGeneralForumTopic"; chat_id, name)
end

close_general_forum_topic(chat_id::Union{Int64,String}) =
    _make_request(Bool, "closeGeneralForumTopic"; chat_id)

reopen_general_forum_topic(chat_id::Union{Int64,String}) =
    _make_request(Bool, "reopenGeneralForumTopic"; chat_id)

hide_general_forum_topic(chat_id::Union{Int64,String}) =
    _make_request(Bool, "hideGeneralForumTopic"; chat_id)

unhide_general_forum_topic(chat_id::Union{Int64,String}) =
    _make_request(Bool, "unhideGeneralForumTopic"; chat_id)

unpin_all_general_forum_topic_messages(chat_id::Union{Int64,String}) =
    _make_request(Bool, "unpinAllGeneralForumTopicMessages"; chat_id)

# ===== Inline mode ==========================================================

function answer_inline_query(inline_query_id::String, results::Vector;
        cache_time=nothing, is_personal=nothing, next_offset=nothing,
        button=nothing)
    _make_request(Bool, "answerInlineQuery"; inline_query_id, results,
        cache_time, is_personal, next_offset, button)
end

# ===== Payments =============================================================

function send_invoice(chat_id::Union{Int64,String}, title::String, description::String,
        payload::String, currency::String, prices::Vector{LabeledPrice};
        provider_token=nothing, max_tip_amount=nothing,
        suggested_tip_amounts=nothing, start_parameter=nothing,
        provider_data=nothing, photo_url=nothing, photo_size=nothing,
        photo_width=nothing, photo_height=nothing,
        need_name=nothing, need_phone_number=nothing, need_email=nothing,
        need_shipping_address=nothing, send_phone_number_to_provider=nothing,
        send_email_to_provider=nothing, is_flexible=nothing,
        disable_notification=nothing, protect_content=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        message_thread_id=nothing, business_connection_id=nothing)
    _make_request(Message, "sendInvoice"; chat_id, title, description,
        payload, currency, prices, provider_token, max_tip_amount,
        suggested_tip_amounts, start_parameter, provider_data,
        photo_url, photo_size, photo_width, photo_height,
        need_name, need_phone_number, need_email, need_shipping_address,
        send_phone_number_to_provider, send_email_to_provider, is_flexible,
        disable_notification, protect_content, reply_parameters, reply_markup,
        message_thread_id, business_connection_id)
end

function answer_shipping_query(shipping_query_id::String, ok::Bool;
        shipping_options=nothing, error_message=nothing)
    _make_request(Bool, "answerShippingQuery"; shipping_query_id, ok,
        shipping_options, error_message)
end

function answer_pre_checkout_query(pre_checkout_query_id::String, ok::Bool;
        error_message=nothing)
    _make_request(Bool, "answerPreCheckoutQuery"; pre_checkout_query_id, ok,
        error_message)
end

# ===== Stickers =============================================================

get_sticker_set(name::String) =
    _make_request(StickerSet, "getStickerSet"; name)

get_custom_emoji_stickers(custom_emoji_ids::Vector{String}) =
    _make_request(Vector{Sticker}, "getCustomEmojiStickers"; custom_emoji_ids)

# ===== Games ================================================================

function send_game(chat_id::Int64, game_short_name::String;
        disable_notification=nothing, protect_content=nothing,
        reply_parameters=nothing, reply_markup=nothing,
        business_connection_id=nothing, message_effect_id=nothing)
    _make_request(Message, "sendGame"; chat_id, game_short_name,
        disable_notification, protect_content, reply_parameters,
        reply_markup, business_connection_id, message_effect_id)
end

function set_game_score(user_id::Int64, score::Int64;
        force=nothing, disable_edit_message=nothing,
        chat_id=nothing, message_id=nothing, inline_message_id=nothing)
    T = inline_message_id !== nothing ? Bool : Message
    _make_request(T, "setGameScore"; user_id, score,
        force, disable_edit_message, chat_id, message_id, inline_message_id)
end

function get_game_high_scores(user_id::Int64;
        chat_id=nothing, message_id=nothing, inline_message_id=nothing)
    _make_request(Vector{GameHighScore}, "getGameHighScores"; user_id,
        chat_id, message_id, inline_message_id)
end
