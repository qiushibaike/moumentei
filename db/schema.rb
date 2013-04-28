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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130326132509) do

  create_table "announcements", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anonymous_ratings", :force => true do |t|
    t.integer "ip",                        :null => false
    t.integer "article_id",                :null => false
    t.integer "score",      :default => 1
  end

  add_index "anonymous_ratings", ["ip", "article_id"], :name => "index_anonymous_ratings_on_ip_and_article_id", :unique => true

  create_table "article_references", :id => false, :force => true do |t|
    t.integer "referer", :null => false
    t.integer "source",  :null => false
  end

  add_index "article_references", ["source", "referer"], :name => "index_article_references_on_source_and_referer", :unique => true

  create_table "article_trackbacks", :force => true do |t|
    t.integer "article_id"
    t.string  "trackback_id"
    t.string  "platform"
    t.string  "link"
  end

  create_table "articles", :force => true do |t|
    t.string   "tag_line"
    t.integer  "group_id",                           :default => 0,           :null => false
    t.integer  "user_id",                            :default => 0,           :null => false
    t.string   "title"
    t.string   "status",               :limit => 20, :default => "pending", :null => false
    t.string   "comment_status",       :limit => 20, :default => "open",    :null => false
    t.boolean  "anonymous",                          :default => false,       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "email"
    t.integer  "pos",                                :default => 0
    t.integer  "neg",                                :default => 0
    t.integer  "score",                              :default => 0
    t.datetime "published_at"
    t.text     "content"
    t.integer  "alt_score",                          :default => 0
  end

  add_index "articles", ["created_at", "group_id", "status"], :name => "created_at"
  add_index "articles", ["created_at"], :name => "index_articles_on_created_at"
  add_index "articles", ["group_id", "status", "alt_score"], :name => "index_articles_on_group_id_and_status_and_alt_score"
  add_index "articles", ["group_id", "status", "published_at", "score"], :name => "index_articles_on_group_id_and_status_and_published_at_and_score"
  add_index "articles", ["group_id", "status", "updated_at"], :name => "index_articles_on_group_id_and_status_and_updated_at"
  add_index "articles", ["group_id", "status"], :name => "index_articles_on_group_id_and_status"
  add_index "articles", ["id", "status"], :name => "index_articles_on_id_and_status"
  add_index "articles", ["status", "group_id", "id"], :name => "status"

  create_table "badges", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "title",             :null => false
    t.string   "description"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  add_index "badges", ["name"], :name => "index_badges_on_name", :unique => true

  create_table "badges_users", :id => false, :force => true do |t|
    t.integer  "badge_id",   :default => 0, :null => false
    t.integer  "user_id",    :default => 0, :null => false
    t.datetime "created_at"
  end

  create_table "balances", :force => true do |t|
    t.integer  "charm",      :default => 0, :null => false
    t.integer  "credit",     :default => 0, :null => false
    t.integer  "level",      :default => 0, :null => false
    t.integer  "user_id",                   :null => false
    t.integer  "neg",        :default => 0, :null => false
    t.integer  "pos",        :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "balances", ["user_id"], :name => "index_balances_on_user_id", :unique => true

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 20
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "code_logs", :force => true do |t|
    t.integer "user_id", :null => false
    t.date    "date",    :null => false
  end

  add_index "code_logs", ["user_id", "date"], :name => "index_code_logs_on_user_id_and_date", :unique => true

  create_table "comment_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_ratings", ["user_id", "comment_id", "score"], :name => "full_idx"
  add_index "comment_ratings", ["user_id", "comment_id"], :name => "index_comment_ratings_on_user_id_and_comment_id", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                  :default => 0,         :null => false
    t.integer  "article_id",                                      :null => false
    t.integer  "floor"
    t.datetime "created_at",                                      :null => false
    t.string   "status",     :limit => 20, :default => "pending", :null => false
    t.boolean  "anonymous",                :default => false,     :null => false
    t.integer  "pos",                      :default => 0
    t.integer  "neg",                      :default => 0
    t.text     "content"
    t.integer  "score"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "link"
  end

  add_index "comments", ["article_id", "floor"], :name => "index_comments_on_article_id_and_floor", :unique => true
  add_index "comments", ["article_id", "score"], :name => "index_comments_on_article_id_and_score"
  add_index "comments", ["article_id", "status"], :name => "article_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "favorites", :force => true do |t|
    t.integer  "favorable_id",                 :null => false
    t.integer  "user_id",                      :null => false
    t.string   "favorable_type", :limit => 30, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["user_id", "favorable_id", "favorable_type"], :name => "favorable_id", :unique => true

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "friend_id",  :null => false
    t.datetime "created_at"
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "description"
    t.datetime "created_at"
    t.integer  "parent_id"
    t.integer  "lft",         :default => 0, :null => false
    t.integer  "rgt",         :default => 0, :null => false
    t.string   "domain"
    t.string   "alias"
    t.text     "options"
  end

  add_index "groups", ["alias"], :name => "index_groups_on_alias"
  add_index "groups", ["domain"], :name => "index_groups_on_domain"
  add_index "groups", ["lft"], :name => "index_groups_on_lft"
  add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
  add_index "groups", ["rgt"], :name => "index_groups_on_rgt"

  create_table "invitation_codes", :force => true do |t|
    t.string   "code",         :null => false
    t.integer  "applicant_id", :null => false
    t.integer  "consumer_id"
    t.datetime "created_at"
    t.datetime "consumed_at"
    t.datetime "updated_at"
  end

  add_index "invitation_codes", ["applicant_id"], :name => "index_invitation_codes_on_applicant_id"
  add_index "invitation_codes", ["code"], :name => "index_invitation_codes_on_code", :unique => true

  create_table "list_items", :force => true do |t|
    t.integer  "article_id",                :null => false
    t.integer  "list_id",                   :null => false
    t.integer  "position",   :default => 0, :null => false
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "user_id",                       :null => false
    t.boolean  "private",    :default => false, :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.integer "state",    :default => 0
  end

  create_table "messages", :force => true do |t|
    t.integer  "owner_id",                        :null => false
    t.integer  "sender_id",                       :null => false
    t.integer  "recipient_id",                    :null => false
    t.text     "content",                         :null => false
    t.boolean  "read",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["owner_id", "sender_id", "read"], :name => "owner_id"

  create_table "metadatas", :force => true do |t|
    t.integer  "article_id"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metadatas", ["article_id", "key"], :name => "index_metadatas_on_article_id_and_key", :unique => true

  create_table "name_logs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "name_logs", ["user_id"], :name => "index_name_logs_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",       :default => false, :null => false
  end

  add_index "notifications", ["user_id", "key"], :name => "user_id", :unique => true

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 20
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "pages", :force => true do |t|
    t.integer  "group_id"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "slug"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["group_id", "parent_id"], :name => "index_pages_on_group_id_and_parent_id"
  add_index "pages", ["path"], :name => "index_pages_on_path"
  add_index "pages", ["user_id"], :name => "index_pages_on_user_id"

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.boolean  "reshare"
    t.string   "title"
    t.string   "source"
    t.string   "device"
  end

  add_index "posts", ["parent_id", "reshare"], :name => "index_posts_on_parent_id_and_reshare"

  create_table "preferences", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "owner_id",   :null => false
    t.string   "owner_type", :null => false
    t.integer  "group_id"
    t.string   "group_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], :name => "index_preferences_on_owner_and_name_and_preference", :unique => true

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "realname"
    t.string   "phonenumber"
    t.string   "sex",         :limit => 20, :default => "unknown"
    t.string   "job"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "article_id",                :null => false
    t.integer  "user_id",    :default => 0, :null => false
    t.integer  "score",      :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "ratings", ["article_id", "user_id"], :name => "pk_ratings", :unique => true
  add_index "ratings", ["score"], :name => "index_ratings_on_score"

  create_table "reports", :force => true do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.text     "info"
    t.integer  "report_times"
    t.integer  "operator_id"
    t.string   "result"
    t.datetime "operated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string "key",   :limit => 64, :null => false
    t.text   "value",               :null => false
  end

  add_index "settings", ["key"], :name => "index_settings_on_key", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",                                                         :null => false
    t.integer  "taggable_id",                                                    :null => false
    t.string   "taggable_type", :limit => 20, :default => "Article",             :null => false
    t.datetime "created_at",                  :default => '2008-01-01 00:00:00', :null => false
  end

  add_index "taggings", ["created_at"], :name => "index_taggings_on_created_at"
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "tag_target", :unique => true
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "description"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean  "hide"
  end

  add_index "tags", ["id", "name"], :name => "id"
  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "ticket_types", :force => true do |t|
    t.string  "name",                       :null => false
    t.string  "description"
    t.integer "weight",      :default => 0, :null => false
    t.boolean "need_reason"
    t.string  "callback"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "user_id",                              :null => false
    t.integer  "article_id",                           :null => false
    t.integer  "ticket_type_id"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reason"
    t.string   "sort",           :default => "normal"
    t.datetime "viewed_at"
  end

  add_index "tickets", ["article_id"], :name => "fk_article_id"
  add_index "tickets", ["user_id", "article_id"], :name => "index_tickets_on_user_id_and_article_id", :unique => true

  create_table "transactions", :force => true do |t|
    t.integer  "balance_id",                :null => false
    t.integer  "amount",     :default => 0, :null => false
    t.string   "reason"
    t.datetime "created_at"
  end

  add_index "transactions", ["balance_id"], :name => "index_transactions_on_balance_id"
  add_index "transactions", ["created_at"], :name => "index_transactions_on_created_at"

  create_table "user_stats", :force => true do |t|
    t.integer "user_id",                           :null => false
    t.integer "anonymous_comments", :default => 0, :null => false
    t.integer "public_comments",    :default => 0, :null => false
    t.integer "public_sofas",       :default => 0, :null => false
    t.integer "public_articles",    :default => 0, :null => false
    t.integer "anonymous_articles", :default => 0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                                             :null => false
    t.string   "name",                      :limit => 100
    t.string   "email",                                                             :null => false
    t.string   "crypted_password",                                                  :null => false
    t.string   "salt",                                                              :null => false
    t.string   "created_at",                                                        :null => false
    t.string   "updated_at",                                                        :null => false
    t.string   "remember_token",                           :default => "",        :null => false
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["activation_code"], :name => "activation_code"
  add_index "users", ["email"], :name => "email"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["login"], :name => "login"
  add_index "users", ["remember_token"], :name => "remember_token"
  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "users_roles", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id", :unique => true

  create_table "weights", :force => true do |t|
    t.integer "user_id",     :null => false
    t.integer "neg"
    t.integer "pos"
    t.integer "correct"
    t.integer "pos_correct"
    t.integer "neg_correct"
    t.float   "adjust"
  end

  add_index "weights", ["user_id"], :name => "index_weights_on_user_id", :unique => true

end
