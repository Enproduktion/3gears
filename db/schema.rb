# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161021141302) do

  create_table "article_contents", force: :cascade do |t|
    t.integer "article_id", limit: 4,                  null: false
    t.string  "locale",     limit: 255,                null: false
    t.string  "title",      limit: 255,   default: "", null: false
    t.text    "abstract",   limit: 65535,              null: false
    t.text    "body",       limit: 65535,              null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "view_count",      limit: 4, default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",     limit: 4, default: 0, null: false
    t.datetime "published_at"
    t.integer  "category_id",     limit: 4
    t.integer  "user_id",         limit: 4
    t.integer  "viewable_by_all", limit: 4, default: 0
  end

  add_index "articles", ["created_at"], name: "index_articles_on_created_at", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree
  add_index "articles", ["view_count"], name: "index_articles_on_view_count", using: :btree

  create_table "assets", force: :cascade do |t|
    t.integer  "article_id",           limit: 4,   null: false
    t.string   "content_file_name",    limit: 255
    t.string   "content_content_type", limit: 255
    t.integer  "content_file_size",    limit: 4
    t.datetime "content_updated_at"
    t.integer  "position",             limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["article_id"], name: "index_assets_on_article_id", using: :btree
  add_index "assets", ["position"], name: "index_assets_on_position", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string "category_type", limit: 255, null: false
    t.string "name",          limit: 255, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",          limit: 4,     null: false
    t.integer  "commentable_id",   limit: 4,     null: false
    t.string   "commentable_type", limit: 255,   null: false
    t.text     "content",          limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_id",       limit: 4
  end

  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id", using: :btree
  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "crew_members", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "work_id",       limit: 4,   null: false
    t.string   "work_type",     limit: 255, null: false
    t.string   "invited_email", limit: 255
    t.string   "occupation",    limit: 255, null: false
    t.datetime "created_at"
  end

  add_index "crew_members", ["user_id"], name: "index_crew_members_on_user_id", using: :btree
  add_index "crew_members", ["work_id", "work_type", "invited_email", "occupation"], name: "_unique_occupation1", unique: true, using: :btree
  add_index "crew_members", ["work_id", "work_type", "user_id", "occupation"], name: "_unique_occupation2", unique: true, using: :btree
  add_index "crew_members", ["work_id"], name: "index_crew_members_on_work_id", using: :btree
  add_index "crew_members", ["work_type"], name: "index_crew_members_on_work_type", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.integer  "movie_or_idea_id",      limit: 4
  end

  create_table "equipments", force: :cascade do |t|
    t.string  "tool",             limit: 255
    t.string  "manufacture",      limit: 255
    t.string  "model",            limit: 255
    t.integer "movie_or_idea_id", limit: 4
    t.integer "supplier_id",      limit: 4
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "message",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.integer "user_id",     limit: 4,   null: false
    t.string  "tag_name",    limit: 255
    t.integer "category_id", limit: 4
    t.string  "kind",        limit: 255
  end

  add_index "feeds", ["category_id"], name: "index_feeds_on_category_id", using: :btree
  add_index "feeds", ["tag_name"], name: "index_feeds_on_tag_name", using: :btree
  add_index "feeds", ["user_id", "tag_name", "category_id"], name: "index_feeds_on_user_id_and_tag_name_and_category_id", unique: true, using: :btree
  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id", using: :btree

  create_table "footage", force: :cascade do |t|
    t.string   "title",                limit: 255,   default: "",    null: false
    t.text     "abstract",             limit: 65535,                 null: false
    t.boolean  "published",                          default: false, null: false
    t.integer  "user_id",              limit: 4
    t.integer  "category_id",          limit: 4
    t.integer  "viewable_by_all",      limit: 4,     default: 1,     null: false
    t.integer  "view_count",           limit: 4,     default: 0,     null: false
    t.integer  "likes_count",          limit: 4,     default: 0,     null: false
    t.string   "camera",               limit: 255
    t.string   "lense",                limit: 255
    t.integer  "focal_distance",       limit: 4
    t.string   "color",                limit: 255
    t.string   "ratio",                limit: 255
    t.string   "audio_recorder",       limit: 255
    t.string   "audio_mixer",          limit: 255
    t.string   "microphone",           limit: 255
    t.boolean  "analog"
    t.string   "film",                 limit: 255
    t.integer  "speed",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "locale",               limit: 255
    t.text     "synopsis",             limit: 65535
    t.integer  "organisation_id",      limit: 4
    t.boolean  "is_organisation",                    default: false
    t.string   "caption_file_name",    limit: 255
    t.string   "caption_content_type", limit: 255
    t.integer  "caption_file_size",    limit: 4
    t.datetime "caption_updated_at"
  end

  add_index "footage", ["created_at"], name: "index_footage_on_created_at", using: :btree
  add_index "footage", ["organisation_id"], name: "index_footage_on_organisation_id", using: :btree
  add_index "footage", ["published"], name: "index_footage_on_published", using: :btree
  add_index "footage", ["user_id"], name: "index_footage_on_user_id", using: :btree
  add_index "footage", ["view_count"], name: "index_footage_on_view_count", using: :btree
  add_index "footage", ["viewable_by_all"], name: "index_footage_on_viewable_by_all", using: :btree

  create_table "footage_metadata", force: :cascade do |t|
    t.integer  "footage_id",        limit: 4
    t.string   "country",           limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "cast",              limit: 65535
    t.text     "original_format",   limit: 65535
    t.text     "original_length",   limit: 65535
    t.text     "original_language", limit: 65535
    t.integer  "year_of_reference", limit: 4
    t.text     "genre",             limit: 65535
    t.text     "citations",         limit: 65535
    t.text     "source",            limit: 65535
  end

  create_table "footage_movies_and_ideas", id: false, force: :cascade do |t|
    t.integer  "movie_or_idea_id", limit: 4, null: false
    t.integer  "footage_id",       limit: 4, null: false
    t.datetime "created_at"
  end

  add_index "footage_movies_and_ideas", ["footage_id"], name: "index_footage_movies_and_ideas_on_footage_id", using: :btree
  add_index "footage_movies_and_ideas", ["movie_or_idea_id", "footage_id"], name: "_unique_relation", unique: true, using: :btree
  add_index "footage_movies_and_ideas", ["movie_or_idea_id"], name: "index_footage_movies_and_ideas_on_movie_or_idea_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "token",      limit: 255, null: false
    t.string   "email",      limit: 255, null: false
    t.datetime "created_at"
  end

  add_index "invitations", ["token"], name: "index_invitations_on_token", unique: true, using: :btree

  create_table "languages", primary_key: "name", force: :cascade do |t|
  end

  create_table "licenses", force: :cascade do |t|
    t.integer "material_id",         limit: 4,                  null: false
    t.string  "material_type",       limit: 255,                null: false
    t.string  "holder_name",         limit: 255,   default: "", null: false
    t.string  "holder_email",        limit: 255,   default: "", null: false
    t.text    "holder_address",      limit: 65535,              null: false
    t.string  "custom_license_name", limit: 255
    t.string  "custom_license_url",  limit: 255
    t.string  "preset_name",         limit: 255
  end

  add_index "licenses", ["material_id"], name: "index_licenses_on_material_id", using: :btree
  add_index "licenses", ["material_type"], name: "index_licenses_on_material_type", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,   null: false
    t.integer  "likeable_id",   limit: 4,   null: false
    t.string   "likeable_type", limit: 255, null: false
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id"], name: "index_likes_on_likeable_id", using: :btree
  add_index "likes", ["likeable_type"], name: "index_likes_on_likeable_type", using: :btree
  add_index "likes", ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true, using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "media", force: :cascade do |t|
    t.string   "medium_use",             limit: 255,   default: "",            null: false
    t.string   "status",                 limit: 255,   default: "tabula_rasa", null: false
    t.integer  "filesize",               limit: 8
    t.integer  "likes_count",            limit: 4,     default: 0,             null: false
    t.integer  "referer_id",             limit: 4,                             null: false
    t.string   "referer_type",           limit: 255,   default: "",            null: false
    t.integer  "thumbnail_index",        limit: 4
    t.string   "thumbnail_file_name",    limit: 255
    t.string   "thumbnail_content_type", limit: 255
    t.integer  "thumbnail_file_size",    limit: 4
    t.datetime "thumbnail_updated_at"
    t.integer  "original_id",            limit: 4
    t.string   "original_filename",      limit: 255
    t.string   "fileserver_handle",      limit: 255
    t.string   "public_name",            limit: 255
    t.float    "bitrate",                limit: 24
    t.integer  "transcoding_preset_id",  limit: 4
    t.text     "transcoder_settings",    limit: 65535
    t.text     "transcoding_error",      limit: 65535
    t.float    "transcoding_duration",   limit: 24
    t.integer  "width",                  limit: 4
    t.integer  "height",                 limit: 4
    t.float    "dar",                    limit: 24
    t.float    "duration",               limit: 24
    t.float    "frame_rate",             limit: 24
    t.string   "audio_codec",            limit: 255
    t.integer  "audio_sample_rate",      limit: 4
    t.integer  "audio_channels",         limit: 4
    t.float    "audio_bitrate",          limit: 24
    t.string   "video_codec",            limit: 255
    t.float    "video_bitrate",          limit: 24
    t.string   "colorspace",             limit: 255
    t.text     "audio_info",             limit: 65535
    t.text     "video_info",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["fileserver_handle"], name: "index_media_on_fileserver_handle", unique: true, using: :btree
  add_index "media", ["medium_use"], name: "index_media_on_medium_use", using: :btree
  add_index "media", ["original_id"], name: "index_media_on_original_id", using: :btree
  add_index "media", ["referer_id"], name: "index_media_on_referer_id", using: :btree
  add_index "media", ["referer_type"], name: "index_media_on_referer_type", using: :btree
  add_index "media", ["status"], name: "index_media_on_status", using: :btree
  add_index "media", ["transcoding_preset_id"], name: "index_media_on_transcoding_preset_id", using: :btree

  create_table "medium_time_tags", force: :cascade do |t|
    t.integer  "medium_id",  limit: 4
    t.integer  "tag_id",     limit: 4
    t.integer  "start_time", limit: 4
    t.integer  "end_time",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "text",       limit: 65535
  end

  add_index "medium_time_tags", ["medium_id"], name: "index_medium_time_tags_on_medium_id", using: :btree
  add_index "medium_time_tags", ["tag_id"], name: "index_medium_time_tags_on_tag_id", using: :btree

  create_table "movies_and_ideas", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "title",               limit: 255,   default: "",    null: false
    t.text     "abstract",            limit: 65535,                 null: false
    t.integer  "budget_needed",       limit: 4,     default: 0,     null: false
    t.integer  "budget_raised",       limit: 4,     default: 0,     null: false
    t.text     "budget_desc",         limit: 65535,                 null: false
    t.string   "flattr_id",           limit: 255,   default: ""
    t.integer  "view_count",          limit: 4,     default: 0,     null: false
    t.integer  "viewable_by_all",     limit: 4,     default: 1,     null: false
    t.boolean  "is_idea",                                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id",         limit: 4
    t.integer  "likes_count",         limit: 4,     default: 0,     null: false
    t.string   "script_file_name",    limit: 255
    t.string   "script_content_type", limit: 255
    t.integer  "script_file_size",    limit: 4
    t.datetime "script_updated_at"
    t.datetime "published_at"
    t.string   "locale",              limit: 255
    t.text     "synopsis",            limit: 65535
    t.integer  "organisation_id",     limit: 4
    t.boolean  "is_organisation",                   default: false
  end

  add_index "movies_and_ideas", ["created_at"], name: "index_movies_and_ideas_on_created_at", using: :btree
  add_index "movies_and_ideas", ["is_idea"], name: "index_movies_and_ideas_on_is_idea", using: :btree
  add_index "movies_and_ideas", ["organisation_id"], name: "index_movies_and_ideas_on_organisation_id", using: :btree
  add_index "movies_and_ideas", ["user_id"], name: "index_movies_and_ideas_on_user_id", using: :btree
  add_index "movies_and_ideas", ["view_count"], name: "index_movies_and_ideas_on_view_count", using: :btree
  add_index "movies_and_ideas", ["viewable_by_all"], name: "index_movies_and_ideas_on_viewable_by_all", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",           limit: 4,                    null: false
    t.string   "notification_type", limit: 255,   default: "",   null: false
    t.integer  "object_id",         limit: 4,                    null: false
    t.string   "object_type",       limit: 255,   default: "",   null: false
    t.boolean  "unread",                          default: true, null: false
    t.text     "message",           limit: 65535
    t.datetime "created_at"
  end

  add_index "notifications", ["notification_type"], name: "index_notifications_on_notification_type", using: :btree

  create_table "occupations", force: :cascade do |t|
    t.integer "occupationable_id",   limit: 4
    t.string  "occupationable_type", limit: 255
    t.integer "user_id",             limit: 4
    t.string  "occupation",          limit: 255
  end

  add_index "occupations", ["occupationable_id", "occupationable_type"], name: "index_occupations_on_occupationable_id_and_occupationable_type", using: :btree

  create_table "organisations", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "name",                limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.string   "token",               limit: 255
    t.boolean  "confirmed",                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "abstract",            limit: 65535
    t.integer  "likes_count",         limit: 4,     default: 0
    t.string   "email",               limit: 255
    t.string   "country",             limit: 255
    t.string   "zip",                 limit: 255
    t.string   "city",                limit: 255
    t.string   "first_address",       limit: 255
    t.string   "second_address",      limit: 255
    t.string   "cover_file_name",     limit: 255
    t.string   "cover_content_type",  limit: 255
    t.integer  "cover_file_size",     limit: 4
    t.datetime "cover_updated_at"
  end

  create_table "publication_entries", id: false, force: :cascade do |t|
    t.integer  "publication_id",   limit: 4,  default: 0,  null: false
    t.string   "publication_type", limit: 11, default: "", null: false
    t.string   "publication_kind", limit: 8,  default: "", null: false
    t.integer  "category_id",      limit: 4
    t.integer  "viewable_by",      limit: 4
    t.datetime "published_at"
  end

  create_table "report_violations", force: :cascade do |t|
    t.integer  "report_type",     limit: 4
    t.string   "message",         limit: 255
    t.integer  "reportable_id",   limit: 4
    t.string   "reportable_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_violations", ["reportable_id", "reportable_type"], name: "index_report_violations_on_reportable_id_and_reportable_type", using: :btree
  add_index "report_violations", ["user_id"], name: "index_report_violations_on_user_id", using: :btree

  create_table "specs", force: :cascade do |t|
    t.string   "spec",          limit: 255
    t.string   "value",         limit: 255
    t.integer  "specable_id",   limit: 4
    t.string   "specable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "specs", ["specable_id", "specable_type"], name: "index_specs_on_specable_id_and_specable_type", using: :btree

  create_table "stills", force: :cascade do |t|
    t.integer  "movie_or_idea_id",     limit: 4,                  null: false
    t.string   "title",                limit: 255,   default: "", null: false
    t.text     "abstract",             limit: 65535,              null: false
    t.string   "content_file_name",    limit: 255
    t.string   "content_content_type", limit: 255
    t.integer  "content_file_size",    limit: 4
    t.datetime "content_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stills", ["movie_or_idea_id"], name: "index_stills_on_movie_or_idea_id", using: :btree

  create_table "stuff", force: :cascade do |t|
    t.integer  "supplier_id",   limit: 4
    t.integer  "usedfor_id",    limit: 4,                null: false
    t.string   "usedfor_type",  limit: 255,              null: false
    t.string   "invited_email", limit: 255
    t.string   "name",          limit: 255, default: "", null: false
    t.datetime "created_at"
  end

  add_index "stuff", ["supplier_id"], name: "index_stuff_on_supplier_id", using: :btree
  add_index "stuff", ["usedfor_id"], name: "index_stuff_on_usedfor_id", using: :btree
  add_index "stuff", ["usedfor_type"], name: "index_stuff_on_usedfor_type", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id",     limit: 4,                null: false
    t.integer "object_id",   limit: 4,                null: false
    t.string  "object_type", limit: 255, default: "", null: false
    t.string  "event",       limit: 255, default: "", null: false
  end

  add_index "subscriptions", ["user_id", "object_id", "object_type", "event"], name: "_unique", unique: true, using: :btree

  create_table "tag_references", force: :cascade do |t|
    t.integer  "taggable_id",   limit: 4,   null: false
    t.string   "taggable_type", limit: 255, null: false
    t.datetime "created_at"
    t.integer  "tag_id",        limit: 4
  end

  add_index "tag_references", ["tag_id"], name: "index_tag_references_on_tag_id", using: :btree
  add_index "tag_references", ["taggable_id"], name: "index_tag_references_on_taggable_id", using: :btree
  add_index "tag_references", ["taggable_type"], name: "index_tag_references_on_taggable_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "transcoding_presets", force: :cascade do |t|
    t.string  "name",                limit: 255,   default: "", null: false
    t.text    "desc",                limit: 65535,              null: false
    t.string  "use",                 limit: 255,                null: false
    t.text    "settings",            limit: 65535,              null: false
    t.string  "extension",           limit: 255,                null: false
    t.integer "active_above_height", limit: 4
    t.boolean "active",                                         null: false
    t.string  "mime_type",           limit: 255,   default: ""
  end

  create_table "user_organisations", force: :cascade do |t|
    t.integer "user_id",         limit: 4
    t.integer "organisation_id", limit: 4
  end

  add_index "user_organisations", ["organisation_id"], name: "index_user_organisations_on_organisation_id", using: :btree
  add_index "user_organisations", ["user_id"], name: "index_user_organisations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255,                    null: false
    t.string   "username",             limit: 255,                    null: false
    t.string   "crypted_password",     limit: 255,                    null: false
    t.string   "password_salt",        limit: 255,                    null: false
    t.string   "persistence_token",    limit: 255,                    null: false
    t.string   "perishable_token",     limit: 255,                    null: false
    t.integer  "failed_login_count",   limit: 4,     default: 0,      null: false
    t.datetime "current_login_at"
    t.string   "current_login_ip",     limit: 255
    t.datetime "last_login_at"
    t.string   "last_login_ip",        limit: 255
    t.string   "first_name",           limit: 255,   default: "",     null: false
    t.string   "last_name",            limit: 255,   default: "",     null: false
    t.text     "abstract",             limit: 65535,                  null: false
    t.string   "field_of_work",        limit: 255,   default: "",     null: false
    t.boolean  "confirmed",                          default: false,  null: false
    t.string   "new_email",            limit: 255
    t.string   "new_email_token",      limit: 255
    t.string   "role",                 limit: 255,   default: "user", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",          limit: 4,     default: 0,      null: false
    t.string   "avatar_file_name",     limit: 255
    t.string   "avatar_content_type",  limit: 255
    t.integer  "avatar_file_size",     limit: 4
    t.datetime "avatar_updated_at"
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.string   "language",             limit: 255
    t.boolean  "hidden",                             default: false,  null: false
    t.string   "country",              limit: 255
    t.string   "zip",                  limit: 255
    t.string   "city",                 limit: 255
    t.string   "first_address",        limit: 255
    t.string   "second_address",       limit: 255
    t.string   "cover_file_name",      limit: 255
    t.string   "cover_content_type",   limit: 255
    t.integer  "cover_file_size",      limit: 4
    t.datetime "cover_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "viewable_footage_by", id: false, force: :cascade do |t|
    t.integer "footage_id",  limit: 4, default: 0, null: false
    t.integer "viewable_by", limit: 4
  end

  create_table "viewable_movies_and_ideas_by", id: false, force: :cascade do |t|
    t.integer "movie_id",    limit: 4, default: 0, null: false
    t.integer "viewable_by", limit: 4
  end

  add_foreign_key "medium_time_tags", "media"
  add_foreign_key "medium_time_tags", "tags"
  add_foreign_key "tag_references", "tags"
end
