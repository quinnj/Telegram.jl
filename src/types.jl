# ============================================================================
# Telegram Bot API Types
# https://core.telegram.org/bots/api
#
# Organized in dependency order — types are defined before they are referenced.
# ============================================================================

# ===== Group 1: Simple leaf types (no Telegram type dependencies) ===========

struct WebAppInfo
    url::String
end

@defaults struct LoginUrl
    url::String
    forward_text::Union{String, Nothing} = nothing
    bot_username::Union{String, Nothing} = nothing
    request_write_access::Union{Bool, Nothing} = nothing
end

@defaults struct SwitchInlineQueryChosenChat
    query::Union{String, Nothing} = nothing
    allow_user_chats::Union{Bool, Nothing} = nothing
    allow_bot_chats::Union{Bool, Nothing} = nothing
    allow_group_chats::Union{Bool, Nothing} = nothing
    allow_channel_chats::Union{Bool, Nothing} = nothing
end

struct CallbackGame end

struct CopyTextButton
    text::String
end

@kwarg struct LinkPreviewOptions
    is_disabled::Union{Bool, Nothing} = nothing
    url::Union{String, Nothing} = nothing
    prefer_small_media::Union{Bool, Nothing} = nothing
    prefer_large_media::Union{Bool, Nothing} = nothing
    show_above_text::Union{Bool, Nothing} = nothing
end

@defaults struct KeyboardButtonPollType
    type::Union{String, Nothing} = nothing
end

struct ChatPhoto
    small_file_id::String
    small_file_unique_id::String
    big_file_id::String
    big_file_unique_id::String
end

@defaults struct Location
    latitude::Float64
    longitude::Float64
    horizontal_accuracy::Union{Float64, Nothing} = nothing
    live_period::Union{Int64, Nothing} = nothing
    heading::Union{Int64, Nothing} = nothing
    proximity_alert_radius::Union{Int64, Nothing} = nothing
end

struct ChatLocation
    location::Location
    address::String
end

@defaults struct Birthdate
    day::Int64
    month::Int64
    year::Union{Int64, Nothing} = nothing
end

@kwarg struct ChatPermissions
    can_send_messages::Union{Bool, Nothing} = nothing
    can_send_audios::Union{Bool, Nothing} = nothing
    can_send_documents::Union{Bool, Nothing} = nothing
    can_send_photos::Union{Bool, Nothing} = nothing
    can_send_videos::Union{Bool, Nothing} = nothing
    can_send_video_notes::Union{Bool, Nothing} = nothing
    can_send_voice_notes::Union{Bool, Nothing} = nothing
    can_send_polls::Union{Bool, Nothing} = nothing
    can_send_other_messages::Union{Bool, Nothing} = nothing
    can_add_web_page_previews::Union{Bool, Nothing} = nothing
    can_change_info::Union{Bool, Nothing} = nothing
    can_invite_users::Union{Bool, Nothing} = nothing
    can_pin_messages::Union{Bool, Nothing} = nothing
    can_manage_topics::Union{Bool, Nothing} = nothing
end

@kwarg struct ChatAdministratorRights
    is_anonymous::Bool = false
    can_manage_chat::Bool = false
    can_delete_messages::Bool = false
    can_manage_video_chats::Bool = false
    can_restrict_members::Bool = false
    can_promote_members::Bool = false
    can_change_info::Bool = false
    can_invite_users::Bool = false
    can_post_stories::Bool = false
    can_edit_stories::Bool = false
    can_delete_stories::Bool = false
    can_post_messages::Union{Bool, Nothing} = nothing
    can_edit_messages::Union{Bool, Nothing} = nothing
    can_pin_messages::Union{Bool, Nothing} = nothing
    can_manage_topics::Union{Bool, Nothing} = nothing
end

struct BotCommand
    command::String
    description::String
end

struct BotName
    name::String
end

struct BotDescription
    description::String
end

struct BotShortDescription
    short_description::String
end

struct LabeledPrice
    label::String
    amount::Int64
end

@defaults struct ShippingAddress
    country_code::String
    state::String
    city::String
    street_line1::String
    street_line2::String
    post_code::String
end

@defaults struct MaskPosition
    point::String
    x_shift::Float64
    y_shift::Float64
    scale::Float64
end

@defaults struct TelegramFile
    file_id::String
    file_unique_id::String
    file_size::Union{Int64, Nothing} = nothing
    file_path::Union{String, Nothing} = nothing
end

struct WebAppData
    data::String
    button_text::String
end

struct WriteAccessAllowed
    from_request::Union{Bool, Nothing}
    web_app_name::Union{String, Nothing}
    from_attachment_menu::Union{Bool, Nothing}
end

struct MessageAutoDeleteTimerChanged
    message_auto_delete_time::Int64
end

struct ChatBoostAdded
    boost_count::Int64
end

struct VideoChatScheduled
    start_date::Int64
end

struct VideoChatStarted end

struct VideoChatEnded
    duration::Int64
end

struct ForumTopicClosed end
struct ForumTopicReopened end
struct GeneralForumTopicHidden end
struct GeneralForumTopicUnhidden end
struct GiveawayCreated
    prize_star_count::Union{Int64, Nothing}
end

@defaults struct ForumTopicCreated
    name::String
    icon_color::Int64
    icon_custom_emoji_id::Union{String, Nothing} = nothing
end

@defaults struct ForumTopicEdited
    name::Union{String, Nothing} = nothing
    icon_custom_emoji_id::Union{String, Nothing} = nothing
end

@defaults struct ForumTopic
    message_thread_id::Int64
    name::String
    icon_color::Int64
    icon_custom_emoji_id::Union{String, Nothing} = nothing
end

struct PaidMessagePriceChanged
    paid_message_star_count::Int64
end

struct InputFile
    data::Vector{UInt8}
    filename::String
    content_type::String
end
InputFile(data::Vector{UInt8}, filename::String) = InputFile(data, filename, "application/octet-stream")
InputFile(path::String) = InputFile(read(path), basename(path), "application/octet-stream")

# ===== Group 2: Core entity types ==========================================

@defaults struct User
    id::Int64
    is_bot::Bool
    first_name::String
    last_name::Union{String, Nothing} = nothing
    username::Union{String, Nothing} = nothing
    language_code::Union{String, Nothing} = nothing
    is_premium::Union{Bool, Nothing} = nothing
    added_to_attachment_menu::Union{Bool, Nothing} = nothing
    can_join_groups::Union{Bool, Nothing} = nothing
    can_read_all_group_messages::Union{Bool, Nothing} = nothing
    supports_inline_queries::Union{Bool, Nothing} = nothing
    can_connect_to_business::Union{Bool, Nothing} = nothing
    has_main_web_app::Union{Bool, Nothing} = nothing
end

@defaults struct PhotoSize
    file_id::String
    file_unique_id::String
    width::Int64
    height::Int64
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct Animation
    file_id::String
    file_unique_id::String
    width::Int64
    height::Int64
    duration::Int64
    thumbnail::Union{PhotoSize, Nothing} = nothing
    file_name::Union{String, Nothing} = nothing
    mime_type::Union{String, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct Audio
    file_id::String
    file_unique_id::String
    duration::Int64
    performer::Union{String, Nothing} = nothing
    title::Union{String, Nothing} = nothing
    file_name::Union{String, Nothing} = nothing
    mime_type::Union{String, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
    thumbnail::Union{PhotoSize, Nothing} = nothing
end

@defaults struct Document
    file_id::String
    file_unique_id::String
    thumbnail::Union{PhotoSize, Nothing} = nothing
    file_name::Union{String, Nothing} = nothing
    mime_type::Union{String, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct Video
    file_id::String
    file_unique_id::String
    width::Int64
    height::Int64
    duration::Int64
    thumbnail::Union{PhotoSize, Nothing} = nothing
    file_name::Union{String, Nothing} = nothing
    mime_type::Union{String, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct VideoNote
    file_id::String
    file_unique_id::String
    length::Int64
    duration::Int64
    thumbnail::Union{PhotoSize, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct Voice
    file_id::String
    file_unique_id::String
    duration::Int64
    mime_type::Union{String, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct Contact
    phone_number::String
    first_name::String
    last_name::Union{String, Nothing} = nothing
    user_id::Union{Int64, Nothing} = nothing
    vcard::Union{String, Nothing} = nothing
end

struct Dice
    emoji::String
    value::Int64
end

@defaults struct MessageEntity
    type::String
    offset::Int64
    length::Int64
    url::Union{String, Nothing} = nothing
    user::Union{User, Nothing} = nothing
    language::Union{String, Nothing} = nothing
    custom_emoji_id::Union{String, Nothing} = nothing
end

# ===== Group 3: Types depending on core entities ============================

@defaults struct Chat
    id::Int64
    type::String
    title::Union{String, Nothing} = nothing
    username::Union{String, Nothing} = nothing
    first_name::Union{String, Nothing} = nothing
    last_name::Union{String, Nothing} = nothing
    is_forum::Union{Bool, Nothing} = nothing
end

@defaults struct Story
    chat::Chat
    id::Int64
end

@defaults struct PollOption
    text::String
    voter_count::Int64
    text_entities::Union{Vector{MessageEntity}, Nothing} = nothing
end

@defaults struct Poll
    id::String
    question::String
    options::Vector{PollOption}
    total_voter_count::Int64
    is_closed::Bool
    is_anonymous::Bool
    type::String
    allows_multiple_answers::Bool
    question_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    correct_option_id::Union{Int64, Nothing} = nothing
    explanation::Union{String, Nothing} = nothing
    explanation_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    open_period::Union{Int64, Nothing} = nothing
    close_date::Union{Int64, Nothing} = nothing
end

@defaults struct PollAnswer
    poll_id::String
    option_ids::Vector{Int64}
    voter_chat::Union{Chat, Nothing} = nothing
    user::Union{User, Nothing} = nothing
end

@kwarg struct InputPollOption
    text::String
    text_parse_mode::Union{String, Nothing} = nothing
    text_entities::Union{Vector{MessageEntity}, Nothing} = nothing
end

@defaults struct Venue
    location::Location
    title::String
    address::String
    foursquare_id::Union{String, Nothing} = nothing
    foursquare_type::Union{String, Nothing} = nothing
    google_place_id::Union{String, Nothing} = nothing
    google_place_type::Union{String, Nothing} = nothing
end

# Flattened discriminated union — check `type` field for variant
@defaults struct MessageOrigin
    type::String
    date::Int64
    sender_user::Union{User, Nothing} = nothing
    sender_user_name::Union{String, Nothing} = nothing
    sender_chat::Union{Chat, Nothing} = nothing
    chat::Union{Chat, Nothing} = nothing
    message_id::Union{Int64, Nothing} = nothing
    author_signature::Union{String, Nothing} = nothing
end

@defaults struct TextQuote
    text::String
    position::Int64
    entities::Union{Vector{MessageEntity}, Nothing} = nothing
    is_manual::Union{Bool, Nothing} = nothing
end

@defaults struct SharedUser
    user_id::Int64
    first_name::Union{String, Nothing} = nothing
    last_name::Union{String, Nothing} = nothing
    username::Union{String, Nothing} = nothing
    photo::Union{Vector{PhotoSize}, Nothing} = nothing
end

struct UsersShared
    request_id::Int64
    users::Vector{SharedUser}
end

@defaults struct ChatShared
    request_id::Int64
    chat_id::Int64
    title::Union{String, Nothing} = nothing
    username::Union{String, Nothing} = nothing
    photo::Union{Vector{PhotoSize}, Nothing} = nothing
end

struct ProximityAlertTriggered
    traveler::User
    watcher::User
    distance::Int64
end

struct VideoChatParticipantsInvited
    users::Vector{User}
end

@defaults struct Sticker
    file_id::String
    file_unique_id::String
    type::String
    width::Int64
    height::Int64
    is_animated::Bool
    is_video::Bool
    thumbnail::Union{PhotoSize, Nothing} = nothing
    emoji::Union{String, Nothing} = nothing
    set_name::Union{String, Nothing} = nothing
    mask_position::Union{MaskPosition, Nothing} = nothing
    custom_emoji_id::Union{String, Nothing} = nothing
    needs_repainting::Union{Bool, Nothing} = nothing
    file_size::Union{Int64, Nothing} = nothing
end

@defaults struct Game
    title::String
    description::String
    photo::Vector{PhotoSize}
    text::Union{String, Nothing} = nothing
    text_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    animation::Union{Animation, Nothing} = nothing
end

@defaults struct Invoice
    title::String
    description::String
    start_parameter::String
    currency::String
    total_amount::Int64
end

@defaults struct SuccessfulPayment
    currency::String
    total_amount::Int64
    invoice_payload::String
    telegram_payment_charge_id::String
    provider_payment_charge_id::String
    shipping_option_id::Union{String, Nothing} = nothing
    order_info::Union{Dict{String,Any}, Nothing} = nothing
end

@defaults struct RefundedPayment
    currency::String
    total_amount::Int64
    invoice_payload::String
    telegram_payment_charge_id::String
    provider_payment_charge_id::Union{String, Nothing} = nothing
end

@defaults struct ChatInviteLink
    invite_link::String
    creator::User
    creates_join_request::Bool
    is_primary::Bool
    is_revoked::Bool
    name::Union{String, Nothing} = nothing
    expire_date::Union{Int64, Nothing} = nothing
    member_limit::Union{Int64, Nothing} = nothing
    pending_join_request_count::Union{Int64, Nothing} = nothing
    subscription_period::Union{Int64, Nothing} = nothing
    subscription_price::Union{Int64, Nothing} = nothing
end

@defaults struct PaidMediaInfo
    star_count::Int64
    paid_media::Vector{Dict{String,Any}}
end

# ExternalReplyInfo — flattened, uses Dict for polymorphic sub-fields
@defaults struct ExternalReplyInfo
    origin::MessageOrigin
    chat::Union{Chat, Nothing} = nothing
    message_id::Union{Int64, Nothing} = nothing
    link_preview_options::Union{LinkPreviewOptions, Nothing} = nothing
    animation::Union{Animation, Nothing} = nothing
    audio::Union{Audio, Nothing} = nothing
    document::Union{Document, Nothing} = nothing
    paid_media::Union{PaidMediaInfo, Nothing} = nothing
    photo::Union{Vector{PhotoSize}, Nothing} = nothing
    sticker::Union{Sticker, Nothing} = nothing
    story::Union{Story, Nothing} = nothing
    video::Union{Video, Nothing} = nothing
    video_note::Union{VideoNote, Nothing} = nothing
    voice::Union{Voice, Nothing} = nothing
    has_media_spoiler::Union{Bool, Nothing} = nothing
    contact::Union{Contact, Nothing} = nothing
    dice::Union{Dice, Nothing} = nothing
    game::Union{Game, Nothing} = nothing
    giveaway::Union{Dict{String,Any}, Nothing} = nothing
    giveaway_winners::Union{Dict{String,Any}, Nothing} = nothing
    invoice::Union{Invoice, Nothing} = nothing
    location::Union{Location, Nothing} = nothing
    poll::Union{Poll, Nothing} = nothing
    venue::Union{Venue, Nothing} = nothing
end

@defaults struct Giveaway
    chats::Vector{Chat}
    winners_selection_date::Int64
    winner_count::Int64
    only_new_members::Union{Bool, Nothing} = nothing
    has_public_winners::Union{Bool, Nothing} = nothing
    prize_description::Union{String, Nothing} = nothing
    country_codes::Union{Vector{String}, Nothing} = nothing
    prize_star_count::Union{Int64, Nothing} = nothing
    premium_subscription_month_count::Union{Int64, Nothing} = nothing
end

@defaults struct GiveawayWinners
    chat::Chat
    giveaway_message_id::Int64
    winners_selection_date::Int64
    winner_count::Int64
    winners::Vector{User}
    additional_chat_count::Union{Int64, Nothing} = nothing
    premium_subscription_month_count::Union{Int64, Nothing} = nothing
    unclaimed_prize_count::Union{Int64, Nothing} = nothing
    only_new_members::Union{Bool, Nothing} = nothing
    was_refunded::Union{Bool, Nothing} = nothing
    prize_description::Union{String, Nothing} = nothing
    prize_star_count::Union{Int64, Nothing} = nothing
end

@defaults struct GiveawayCompleted
    winner_count::Int64
    unclaimed_prize_count::Union{Int64, Nothing} = nothing
    giveaway_message::Union{Dict{String,Any}, Nothing} = nothing
end

# ===== Group 4: Keyboard types ==============================================

@kwarg struct KeyboardButtonRequestUsers
    request_id::Int64
    user_is_bot::Union{Bool, Nothing} = nothing
    user_is_premium::Union{Bool, Nothing} = nothing
    max_quantity::Union{Int64, Nothing} = nothing
    request_name::Union{Bool, Nothing} = nothing
    request_username::Union{Bool, Nothing} = nothing
    request_photo::Union{Bool, Nothing} = nothing
end

@kwarg struct KeyboardButtonRequestChat
    request_id::Int64
    chat_is_channel::Bool
    chat_is_forum::Union{Bool, Nothing} = nothing
    chat_has_username::Union{Bool, Nothing} = nothing
    chat_is_created::Union{Bool, Nothing} = nothing
    bot_is_member::Union{Bool, Nothing} = nothing
    request_title::Union{Bool, Nothing} = nothing
    request_username::Union{Bool, Nothing} = nothing
    request_photo::Union{Bool, Nothing} = nothing
end

@kwarg struct KeyboardButton
    text::String
    request_users::Union{KeyboardButtonRequestUsers, Nothing} = nothing
    request_chat::Union{KeyboardButtonRequestChat, Nothing} = nothing
    request_contact::Union{Bool, Nothing} = nothing
    request_location::Union{Bool, Nothing} = nothing
    request_poll::Union{KeyboardButtonPollType, Nothing} = nothing
    web_app::Union{WebAppInfo, Nothing} = nothing
end

@kwarg struct InlineKeyboardButton
    text::String
    url::Union{String, Nothing} = nothing
    callback_data::Union{String, Nothing} = nothing
    web_app::Union{WebAppInfo, Nothing} = nothing
    login_url::Union{LoginUrl, Nothing} = nothing
    switch_inline_query::Union{String, Nothing} = nothing
    switch_inline_query_current_chat::Union{String, Nothing} = nothing
    switch_inline_query_chosen_chat::Union{SwitchInlineQueryChosenChat, Nothing} = nothing
    callback_game::Union{CallbackGame, Nothing} = nothing
    pay::Union{Bool, Nothing} = nothing
    copy_text::Union{CopyTextButton, Nothing} = nothing
end

@kwarg struct ReplyKeyboardMarkup
    keyboard::Vector{Vector{KeyboardButton}}
    is_persistent::Union{Bool, Nothing} = nothing
    resize_keyboard::Union{Bool, Nothing} = nothing
    one_time_keyboard::Union{Bool, Nothing} = nothing
    input_field_placeholder::Union{String, Nothing} = nothing
    selective::Union{Bool, Nothing} = nothing
end

struct InlineKeyboardMarkup
    inline_keyboard::Vector{Vector{InlineKeyboardButton}}
end

@kwarg struct ReplyKeyboardRemove
    remove_keyboard::Bool = true
    selective::Union{Bool, Nothing} = nothing
end

@kwarg struct ForceReply
    force_reply::Bool = true
    input_field_placeholder::Union{String, Nothing} = nothing
    selective::Union{Bool, Nothing} = nothing
end

@kwarg struct ReplyParameters
    message_id::Int64
    chat_id::Union{Int64, String, Nothing} = nothing
    allow_sending_without_reply::Union{Bool, Nothing} = nothing
    text_quote::Union{String, Nothing} = nothing &(name="quote",)
    quote_parse_mode::Union{String, Nothing} = nothing
    quote_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    quote_position::Union{Int64, Nothing} = nothing
end

# ===== Group 5: Message types ===============================================

@defaults struct InaccessibleMessage
    chat::Chat
    message_id::Int64
    date::Int64
end

# Message — the central type. Self-referential via reply_to_message.
@defaults struct Message
    message_id::Int64
    date::Int64
    chat::Chat
    message_thread_id::Union{Int64, Nothing} = nothing
    from::Union{User, Nothing} = nothing
    sender_chat::Union{Chat, Nothing} = nothing
    sender_boost_count::Union{Int64, Nothing} = nothing
    sender_business_bot::Union{User, Nothing} = nothing
    business_connection_id::Union{String, Nothing} = nothing
    forward_origin::Union{MessageOrigin, Nothing} = nothing
    is_topic_message::Union{Bool, Nothing} = nothing
    is_automatic_forward::Union{Bool, Nothing} = nothing
    reply_to_message::Union{Message, Nothing} = nothing
    external_reply::Union{ExternalReplyInfo, Nothing} = nothing
    text_quote::Union{TextQuote, Nothing} = nothing &(name="quote",)
    reply_to_story::Union{Story, Nothing} = nothing
    via_bot::Union{User, Nothing} = nothing
    edit_date::Union{Int64, Nothing} = nothing
    has_protected_content::Union{Bool, Nothing} = nothing
    is_from_offline::Union{Bool, Nothing} = nothing
    media_group_id::Union{String, Nothing} = nothing
    author_signature::Union{String, Nothing} = nothing
    text::Union{String, Nothing} = nothing
    entities::Union{Vector{MessageEntity}, Nothing} = nothing
    link_preview_options::Union{LinkPreviewOptions, Nothing} = nothing
    effect_id::Union{String, Nothing} = nothing
    animation::Union{Animation, Nothing} = nothing
    audio::Union{Audio, Nothing} = nothing
    document::Union{Document, Nothing} = nothing
    paid_media::Union{PaidMediaInfo, Nothing} = nothing
    photo::Union{Vector{PhotoSize}, Nothing} = nothing
    sticker::Union{Sticker, Nothing} = nothing
    story::Union{Story, Nothing} = nothing
    video::Union{Video, Nothing} = nothing
    video_note::Union{VideoNote, Nothing} = nothing
    voice::Union{Voice, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    has_media_spoiler::Union{Bool, Nothing} = nothing
    contact::Union{Contact, Nothing} = nothing
    dice::Union{Dice, Nothing} = nothing
    game::Union{Game, Nothing} = nothing
    poll::Union{Poll, Nothing} = nothing
    venue::Union{Venue, Nothing} = nothing
    location::Union{Location, Nothing} = nothing
    new_chat_members::Union{Vector{User}, Nothing} = nothing
    left_chat_member::Union{User, Nothing} = nothing
    new_chat_title::Union{String, Nothing} = nothing
    new_chat_photo::Union{Vector{PhotoSize}, Nothing} = nothing
    delete_chat_photo::Union{Bool, Nothing} = nothing
    group_chat_created::Union{Bool, Nothing} = nothing
    supergroup_chat_created::Union{Bool, Nothing} = nothing
    channel_chat_created::Union{Bool, Nothing} = nothing
    message_auto_delete_timer_changed::Union{MessageAutoDeleteTimerChanged, Nothing} = nothing
    migrate_to_chat_id::Union{Int64, Nothing} = nothing
    migrate_from_chat_id::Union{Int64, Nothing} = nothing
    pinned_message::Union{Message, Nothing} = nothing
    invoice::Union{Invoice, Nothing} = nothing
    successful_payment::Union{SuccessfulPayment, Nothing} = nothing
    refunded_payment::Union{RefundedPayment, Nothing} = nothing
    users_shared::Union{UsersShared, Nothing} = nothing
    chat_shared::Union{ChatShared, Nothing} = nothing
    connected_website::Union{String, Nothing} = nothing
    write_access_allowed::Union{WriteAccessAllowed, Nothing} = nothing
    proximity_alert_triggered::Union{ProximityAlertTriggered, Nothing} = nothing
    boost_added::Union{ChatBoostAdded, Nothing} = nothing
    forum_topic_created::Union{ForumTopicCreated, Nothing} = nothing
    forum_topic_edited::Union{ForumTopicEdited, Nothing} = nothing
    forum_topic_closed::Union{ForumTopicClosed, Nothing} = nothing
    forum_topic_reopened::Union{ForumTopicReopened, Nothing} = nothing
    general_forum_topic_hidden::Union{GeneralForumTopicHidden, Nothing} = nothing
    general_forum_topic_unhidden::Union{GeneralForumTopicUnhidden, Nothing} = nothing
    giveaway_created::Union{GiveawayCreated, Nothing} = nothing
    giveaway::Union{Giveaway, Nothing} = nothing
    giveaway_winners::Union{GiveawayWinners, Nothing} = nothing
    giveaway_completed::Union{GiveawayCompleted, Nothing} = nothing
    video_chat_scheduled::Union{VideoChatScheduled, Nothing} = nothing
    video_chat_started::Union{VideoChatStarted, Nothing} = nothing
    video_chat_ended::Union{VideoChatEnded, Nothing} = nothing
    video_chat_participants_invited::Union{VideoChatParticipantsInvited, Nothing} = nothing
    web_app_data::Union{WebAppData, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
end

struct MessageId
    message_id::Int64
end

const MaybeInaccessibleMessage = Union{Message, InaccessibleMessage}

# ===== Group 6: Callback, inline, and query types ===========================

@defaults struct CallbackQuery
    id::String
    from::User
    chat_instance::String
    message::Union{Message, Nothing} = nothing
    inline_message_id::Union{String, Nothing} = nothing
    data::Union{String, Nothing} = nothing
    game_short_name::Union{String, Nothing} = nothing
end

@defaults struct InlineQuery
    id::String
    from::User
    query::String
    offset::String
    chat_type::Union{String, Nothing} = nothing
    location::Union{Location, Nothing} = nothing
end

@defaults struct ChosenInlineResult
    result_id::String
    from::User
    query::String
    location::Union{Location, Nothing} = nothing
    inline_message_id::Union{String, Nothing} = nothing
end

@defaults struct ShippingQuery
    id::String
    from::User
    invoice_payload::String
    shipping_address::ShippingAddress
end

@defaults struct PreCheckoutQuery
    id::String
    from::User
    currency::String
    total_amount::Int64
    invoice_payload::String
    shipping_option_id::Union{String, Nothing} = nothing
    order_info::Union{Dict{String,Any}, Nothing} = nothing
end

# ===== Group 7: Chat member types (flattened union) =========================

# Flattened discriminated union — check `status` field for variant:
#   "creator", "administrator", "member", "restricted", "left", "kicked"
@defaults struct ChatMember
    status::String
    user::User
    is_anonymous::Union{Bool, Nothing} = nothing
    custom_title::Union{String, Nothing} = nothing
    can_be_edited::Union{Bool, Nothing} = nothing
    can_manage_chat::Union{Bool, Nothing} = nothing
    can_delete_messages::Union{Bool, Nothing} = nothing
    can_manage_video_chats::Union{Bool, Nothing} = nothing
    can_restrict_members::Union{Bool, Nothing} = nothing
    can_promote_members::Union{Bool, Nothing} = nothing
    can_change_info::Union{Bool, Nothing} = nothing
    can_invite_users::Union{Bool, Nothing} = nothing
    can_post_stories::Union{Bool, Nothing} = nothing
    can_edit_stories::Union{Bool, Nothing} = nothing
    can_delete_stories::Union{Bool, Nothing} = nothing
    can_post_messages::Union{Bool, Nothing} = nothing
    can_edit_messages::Union{Bool, Nothing} = nothing
    can_pin_messages::Union{Bool, Nothing} = nothing
    can_manage_topics::Union{Bool, Nothing} = nothing
    is_member::Union{Bool, Nothing} = nothing
    can_send_messages::Union{Bool, Nothing} = nothing
    can_send_audios::Union{Bool, Nothing} = nothing
    can_send_documents::Union{Bool, Nothing} = nothing
    can_send_photos::Union{Bool, Nothing} = nothing
    can_send_videos::Union{Bool, Nothing} = nothing
    can_send_video_notes::Union{Bool, Nothing} = nothing
    can_send_voice_notes::Union{Bool, Nothing} = nothing
    can_send_polls::Union{Bool, Nothing} = nothing
    can_send_other_messages::Union{Bool, Nothing} = nothing
    can_add_web_page_previews::Union{Bool, Nothing} = nothing
    until_date::Union{Int64, Nothing} = nothing
end

@defaults struct ChatMemberUpdated
    chat::Chat
    from::User
    date::Int64
    old_chat_member::ChatMember
    new_chat_member::ChatMember
    invite_link::Union{ChatInviteLink, Nothing} = nothing
    via_join_request::Union{Bool, Nothing} = nothing
    via_chat_folder_invite_link::Union{Bool, Nothing} = nothing
end

@defaults struct ChatJoinRequest
    chat::Chat
    from::User
    user_chat_id::Int64
    date::Int64
    bio::Union{String, Nothing} = nothing
    invite_link::Union{ChatInviteLink, Nothing} = nothing
end

# ===== Group 8: Reaction types ==============================================

# Flattened — check `type` for "emoji", "custom_emoji_id", or "paid"
@defaults struct ReactionType
    type::String
    emoji::Union{String, Nothing} = nothing
    custom_emoji_id::Union{String, Nothing} = nothing
end

@defaults struct ReactionCount
    type::ReactionType
    total_count::Int64
end

@defaults struct MessageReactionUpdated
    chat::Chat
    message_id::Int64
    date::Int64
    old_reaction::Vector{ReactionType}
    new_reaction::Vector{ReactionType}
    user::Union{User, Nothing} = nothing
    actor_chat::Union{Chat, Nothing} = nothing
end

@defaults struct MessageReactionCountUpdated
    chat::Chat
    message_id::Int64
    date::Int64
    reactions::Vector{ReactionCount}
end

# ===== Group 9: Boost types =================================================

# Flattened — check `source.type` for variant
@defaults struct ChatBoostSource
    source::String
    user::Union{User, Nothing} = nothing
end

@defaults struct ChatBoost
    boost_id::String
    add_date::Int64
    expiration_date::Int64
    source::ChatBoostSource
end

@defaults struct ChatBoostUpdated
    chat::Chat
    boost::ChatBoost
end

@defaults struct ChatBoostRemoved
    chat::Chat
    boost_id::String
    remove_date::Int64
    source::ChatBoostSource
end

@defaults struct UserChatBoosts
    boosts::Vector{ChatBoost}
end

# ===== Group 10: Business types =============================================

@defaults struct BusinessConnection
    id::String
    user::User
    user_chat_id::Int64
    date::Int64
    can_reply::Bool
    is_enabled::Bool
end

@defaults struct BusinessMessagesDeleted
    business_connection_id::String
    chat::Chat
    message_ids::Vector{Int64}
end

# ===== Group 11: Update type ================================================

@defaults struct Update
    update_id::Int64
    message::Union{Message, Nothing} = nothing
    edited_message::Union{Message, Nothing} = nothing
    channel_post::Union{Message, Nothing} = nothing
    edited_channel_post::Union{Message, Nothing} = nothing
    business_connection::Union{BusinessConnection, Nothing} = nothing
    business_message::Union{Message, Nothing} = nothing
    edited_business_message::Union{Message, Nothing} = nothing
    deleted_business_messages::Union{BusinessMessagesDeleted, Nothing} = nothing
    message_reaction::Union{MessageReactionUpdated, Nothing} = nothing
    message_reaction_count::Union{MessageReactionCountUpdated, Nothing} = nothing
    inline_query::Union{InlineQuery, Nothing} = nothing
    chosen_inline_result::Union{ChosenInlineResult, Nothing} = nothing
    callback_query::Union{CallbackQuery, Nothing} = nothing
    shipping_query::Union{ShippingQuery, Nothing} = nothing
    pre_checkout_query::Union{PreCheckoutQuery, Nothing} = nothing
    poll::Union{Poll, Nothing} = nothing
    poll_answer::Union{PollAnswer, Nothing} = nothing
    my_chat_member::Union{ChatMemberUpdated, Nothing} = nothing
    chat_member::Union{ChatMemberUpdated, Nothing} = nothing
    chat_join_request::Union{ChatJoinRequest, Nothing} = nothing
    chat_boost::Union{ChatBoostUpdated, Nothing} = nothing
    removed_chat_boost::Union{ChatBoostRemoved, Nothing} = nothing
end

@defaults struct WebhookInfo
    url::String
    has_custom_certificate::Bool
    pending_update_count::Int64
    ip_address::Union{String, Nothing} = nothing
    last_error_date::Union{Int64, Nothing} = nothing
    last_error_message::Union{String, Nothing} = nothing
    last_synchronization_error_date::Union{Int64, Nothing} = nothing
    max_connections::Union{Int64, Nothing} = nothing
    allowed_updates::Union{Vector{String}, Nothing} = nothing
end

# ===== Group 12: Input media types (for method parameters) ==================

@kwarg struct InputMediaPhoto
    type::String = "photo"
    media::String  # file_id, HTTP URL, or "attach://<file_attach_name>"
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    has_spoiler::Union{Bool, Nothing} = nothing
end

@kwarg struct InputMediaVideo
    type::String = "video"
    media::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    width::Union{Int64, Nothing} = nothing
    height::Union{Int64, Nothing} = nothing
    duration::Union{Int64, Nothing} = nothing
    supports_streaming::Union{Bool, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    has_spoiler::Union{Bool, Nothing} = nothing
end

@kwarg struct InputMediaAnimation
    type::String = "animation"
    media::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    width::Union{Int64, Nothing} = nothing
    height::Union{Int64, Nothing} = nothing
    duration::Union{Int64, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    has_spoiler::Union{Bool, Nothing} = nothing
end

@kwarg struct InputMediaAudio
    type::String = "audio"
    media::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    duration::Union{Int64, Nothing} = nothing
    performer::Union{String, Nothing} = nothing
    title::Union{String, Nothing} = nothing
end

@kwarg struct InputMediaDocument
    type::String = "document"
    media::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    disable_content_type_detection::Union{Bool, Nothing} = nothing
end

const InputMedia = Union{InputMediaPhoto, InputMediaVideo, InputMediaAnimation, InputMediaAudio, InputMediaDocument}

# ===== Group 13: Inline query result types ==================================

@kwarg struct InputTextMessageContent
    message_text::String
    parse_mode::Union{String, Nothing} = nothing
    entities::Union{Vector{MessageEntity}, Nothing} = nothing
    link_preview_options::Union{LinkPreviewOptions, Nothing} = nothing
end

@kwarg struct InputLocationMessageContent
    latitude::Float64
    longitude::Float64
    horizontal_accuracy::Union{Float64, Nothing} = nothing
    live_period::Union{Int64, Nothing} = nothing
    heading::Union{Int64, Nothing} = nothing
    proximity_alert_radius::Union{Int64, Nothing} = nothing
end

@kwarg struct InputVenueMessageContent
    latitude::Float64
    longitude::Float64
    title::String
    address::String
    foursquare_id::Union{String, Nothing} = nothing
    foursquare_type::Union{String, Nothing} = nothing
    google_place_id::Union{String, Nothing} = nothing
    google_place_type::Union{String, Nothing} = nothing
end

@kwarg struct InputContactMessageContent
    phone_number::String
    first_name::String
    last_name::Union{String, Nothing} = nothing
    vcard::Union{String, Nothing} = nothing
end

@kwarg struct InputInvoiceMessageContent
    title::String
    description::String
    payload::String
    currency::String
    prices::Vector{LabeledPrice}
    provider_token::Union{String, Nothing} = nothing
    max_tip_amount::Union{Int64, Nothing} = nothing
    suggested_tip_amounts::Union{Vector{Int64}, Nothing} = nothing
    photo_url::Union{String, Nothing} = nothing
    photo_size::Union{Int64, Nothing} = nothing
    photo_width::Union{Int64, Nothing} = nothing
    photo_height::Union{Int64, Nothing} = nothing
    need_name::Union{Bool, Nothing} = nothing
    need_phone_number::Union{Bool, Nothing} = nothing
    need_email::Union{Bool, Nothing} = nothing
    need_shipping_address::Union{Bool, Nothing} = nothing
    send_phone_number_to_provider::Union{Bool, Nothing} = nothing
    send_email_to_provider::Union{Bool, Nothing} = nothing
    is_flexible::Union{Bool, Nothing} = nothing
end

const InputMessageContent = Union{InputTextMessageContent, InputLocationMessageContent, InputVenueMessageContent, InputContactMessageContent, InputInvoiceMessageContent}

@kwarg struct InlineQueryResultsButton
    text::String
    web_app::Union{WebAppInfo, Nothing} = nothing
    start_parameter::Union{String, Nothing} = nothing
end

@kwarg struct InlineQueryResultArticle
    type::String = "article"
    id::String
    title::String
    input_message_content::InputMessageContent
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    url::Union{String, Nothing} = nothing
    hide_url::Union{Bool, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    thumbnail_url::Union{String, Nothing} = nothing
    thumbnail_width::Union{Int64, Nothing} = nothing
    thumbnail_height::Union{Int64, Nothing} = nothing
end

@kwarg struct InlineQueryResultPhoto
    type::String = "photo"
    id::String
    photo_url::String
    thumbnail_url::String
    photo_width::Union{Int64, Nothing} = nothing
    photo_height::Union{Int64, Nothing} = nothing
    title::Union{String, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultGif
    type::String = "gif"
    id::String
    gif_url::String
    thumbnail_url::String
    gif_width::Union{Int64, Nothing} = nothing
    gif_height::Union{Int64, Nothing} = nothing
    gif_duration::Union{Int64, Nothing} = nothing
    thumbnail_mime_type::Union{String, Nothing} = nothing
    title::Union{String, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultVideo
    type::String = "video"
    id::String
    video_url::String
    mime_type::String
    thumbnail_url::String
    title::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    video_width::Union{Int64, Nothing} = nothing
    video_height::Union{Int64, Nothing} = nothing
    video_duration::Union{Int64, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultAudio
    type::String = "audio"
    id::String
    audio_url::String
    title::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    performer::Union{String, Nothing} = nothing
    audio_duration::Union{Int64, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultDocument
    type::String = "document"
    id::String
    title::String
    document_url::String
    mime_type::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
    thumbnail_url::Union{String, Nothing} = nothing
    thumbnail_width::Union{Int64, Nothing} = nothing
    thumbnail_height::Union{Int64, Nothing} = nothing
end

@kwarg struct InlineQueryResultLocation
    type::String = "location"
    id::String
    latitude::Float64
    longitude::Float64
    title::String
    horizontal_accuracy::Union{Float64, Nothing} = nothing
    live_period::Union{Int64, Nothing} = nothing
    heading::Union{Int64, Nothing} = nothing
    proximity_alert_radius::Union{Int64, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
    thumbnail_url::Union{String, Nothing} = nothing
    thumbnail_width::Union{Int64, Nothing} = nothing
    thumbnail_height::Union{Int64, Nothing} = nothing
end

@kwarg struct InlineQueryResultVenue
    type::String = "venue"
    id::String
    latitude::Float64
    longitude::Float64
    title::String
    address::String
    foursquare_id::Union{String, Nothing} = nothing
    foursquare_type::Union{String, Nothing} = nothing
    google_place_id::Union{String, Nothing} = nothing
    google_place_type::Union{String, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
    thumbnail_url::Union{String, Nothing} = nothing
    thumbnail_width::Union{Int64, Nothing} = nothing
    thumbnail_height::Union{Int64, Nothing} = nothing
end

@kwarg struct InlineQueryResultContact
    type::String = "contact"
    id::String
    phone_number::String
    first_name::String
    last_name::Union{String, Nothing} = nothing
    vcard::Union{String, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
    thumbnail_url::Union{String, Nothing} = nothing
    thumbnail_width::Union{Int64, Nothing} = nothing
    thumbnail_height::Union{Int64, Nothing} = nothing
end

@kwarg struct InlineQueryResultCachedPhoto
    type::String = "photo"
    id::String
    photo_file_id::String
    title::Union{String, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultCachedGif
    type::String = "gif"
    id::String
    gif_file_id::String
    title::Union{String, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultCachedVideo
    type::String = "video"
    id::String
    video_file_id::String
    title::String
    description::Union{String, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    show_caption_above_media::Union{Bool, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultCachedAudio
    type::String = "audio"
    id::String
    audio_file_id::String
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultCachedDocument
    type::String = "document"
    id::String
    title::String
    document_file_id::String
    description::Union{String, Nothing} = nothing
    caption::Union{String, Nothing} = nothing
    parse_mode::Union{String, Nothing} = nothing
    caption_entities::Union{Vector{MessageEntity}, Nothing} = nothing
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

@kwarg struct InlineQueryResultCachedSticker
    type::String = "sticker"
    id::String
    sticker_file_id::String
    reply_markup::Union{InlineKeyboardMarkup, Nothing} = nothing
    input_message_content::Union{InputMessageContent, Nothing} = nothing
end

const InlineQueryResult = Union{
    InlineQueryResultArticle, InlineQueryResultPhoto, InlineQueryResultGif,
    InlineQueryResultVideo, InlineQueryResultAudio, InlineQueryResultDocument,
    InlineQueryResultLocation, InlineQueryResultVenue, InlineQueryResultContact,
    InlineQueryResultCachedPhoto, InlineQueryResultCachedGif,
    InlineQueryResultCachedVideo, InlineQueryResultCachedAudio,
    InlineQueryResultCachedDocument, InlineQueryResultCachedSticker,
}

# ===== Group 14: Payment helper types =======================================

@kwarg struct ShippingOption
    id::String
    title::String
    prices::Vector{LabeledPrice}
end

# ===== Group 15: Sticker set ================================================

@defaults struct StickerSet
    name::String
    title::String
    sticker_type::String
    stickers::Vector{Sticker}
    thumbnail::Union{PhotoSize, Nothing} = nothing
end

@kwarg struct InputSticker
    sticker::String  # file_id or URL
    format::String
    emoji_list::Vector{String}
    mask_position::Union{MaskPosition, Nothing} = nothing
    keywords::Union{Vector{String}, Nothing} = nothing
end

# ===== Group 16: Game high score ============================================

struct GameHighScore
    position::Int64
    user::User
    score::Int64
end

# ===== Group 17: Menu button (flattened) ====================================

@defaults struct MenuButton
    type::String
    text::Union{String, Nothing} = nothing
    web_app::Union{WebAppInfo, Nothing} = nothing
end

# ===== Group 18: User profile photos ========================================

struct UserProfilePhotos
    total_count::Int64
    photos::Vector{Vector{PhotoSize}}
end

# ===== Group 19: ChatFullInfo ===============================================

@defaults struct ChatFullInfo
    id::Int64
    type::String
    accent_color_id::Int64
    max_reaction_count::Int64
    title::Union{String, Nothing} = nothing
    username::Union{String, Nothing} = nothing
    first_name::Union{String, Nothing} = nothing
    last_name::Union{String, Nothing} = nothing
    is_forum::Union{Bool, Nothing} = nothing
    photo::Union{ChatPhoto, Nothing} = nothing
    active_usernames::Union{Vector{String}, Nothing} = nothing
    birthdate::Union{Birthdate, Nothing} = nothing
    personal_chat::Union{Chat, Nothing} = nothing
    available_reactions::Union{Vector{ReactionType}, Nothing} = nothing
    bio::Union{String, Nothing} = nothing
    has_private_forwards::Union{Bool, Nothing} = nothing
    has_restricted_voice_and_video_messages::Union{Bool, Nothing} = nothing
    join_to_send_messages::Union{Bool, Nothing} = nothing
    join_by_request::Union{Bool, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    invite_link::Union{String, Nothing} = nothing
    pinned_message::Union{Message, Nothing} = nothing
    permissions::Union{ChatPermissions, Nothing} = nothing
    can_send_paid_media::Union{Bool, Nothing} = nothing
    slow_mode_delay::Union{Int64, Nothing} = nothing
    unrestrict_boost_count::Union{Int64, Nothing} = nothing
    message_auto_delete_time::Union{Int64, Nothing} = nothing
    has_aggressive_anti_spam_enabled::Union{Bool, Nothing} = nothing
    has_hidden_members::Union{Bool, Nothing} = nothing
    has_protected_content::Union{Bool, Nothing} = nothing
    has_visible_history::Union{Bool, Nothing} = nothing
    sticker_set_name::Union{String, Nothing} = nothing
    can_set_sticker_set::Union{Bool, Nothing} = nothing
    custom_emoji_sticker_set_name::Union{String, Nothing} = nothing
    linked_chat_id::Union{Int64, Nothing} = nothing
    location::Union{ChatLocation, Nothing} = nothing
end
