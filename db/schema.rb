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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140518232930) do

  create_table "achievements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "title"
    t.text     "text"
    t.integer  "change_id"
    t.string   "number"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
  end

  add_index "achievements", ["change_id"], :name => "index_achievements_on_change_id"
  add_index "achievements", ["project_id"], :name => "index_achievements_on_project_id"
  add_index "achievements", ["user_id"], :name => "index_achievements_on_user_id"

  create_table "causes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "coin_file_name"
    t.string   "coin_content_type"
    t.integer  "coin_file_size"
    t.datetime "coin_updated_at"
    t.string   "inactive_coin_file_name"
    t.string   "inactive_coin_content_type"
    t.integer  "inactive_coin_file_size"
    t.datetime "inactive_coin_updated_at"
  end

  create_table "causes_projects", :id => false, :force => true do |t|
    t.integer "cause_id"
    t.integer "project_id"
  end

  create_table "causes_users", :id => false, :force => true do |t|
    t.integer "cause_id"
    t.integer "user_id"
  end

  add_index "causes_users", ["cause_id", "user_id"], :name => "index_causes_users_on_cause_id_and_user_id"
  add_index "causes_users", ["user_id"], :name => "index_causes_users_on_user_id"

  create_table "changes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "sanitized_name"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer  "make_change_category_id"
  end

  add_index "changes", ["make_change_category_id"], :name => "index_changes_on_make_change_category_id"

  create_table "charities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "address"
    t.string   "number"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "slug"
    t.integer  "leader_id"
    t.boolean  "is_public",                   :default => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "chv1_file_name"
    t.string   "chv1_content_type"
    t.integer  "chv1_file_size"
    t.datetime "chv1_updated_at"
    t.string   "contract_file_name"
    t.string   "contract_content_type"
    t.integer  "contract_file_size"
    t.datetime "contract_updated_at"
    t.string   "paying_in_slip_file_name"
    t.string   "paying_in_slip_content_type"
    t.integer  "paying_in_slip_file_size"
    t.datetime "paying_in_slip_updated_at"
    t.string   "hmrc_number"
    t.string   "charity_regulator"
    t.string   "landline_phone"
    t.string   "mobile_phone"
    t.string   "skype"
    t.string   "email"
    t.string   "office_address"
    t.string   "registered_charity_address"
    t.text     "notes"
  end

  add_index "charities", ["leader_id"], :name => "index_charities_on_leader_id"
  add_index "charities", ["slug"], :name => "index_charities_on_slug", :unique => true

  create_table "charities_editors", :id => false, :force => true do |t|
    t.integer "charity_id"
    t.integer "user_id"
  end

  create_table "charities_reporters", :id => false, :force => true do |t|
    t.integer "charity_id"
    t.integer "user_id"
  end

  create_table "charities_users", :force => true do |t|
    t.integer "charity_id"
    t.integer "user_id"
  end

  create_table "charity_join_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "charity_id"
    t.text     "message",    :limit => 300
    t.string   "status",                    :null => false
    t.integer  "admin_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "charity_join_requests", ["admin_id"], :name => "index_charity_join_requests_on_admin_id"
  add_index "charity_join_requests", ["charity_id"], :name => "index_charity_join_requests_on_charity_id"
  add_index "charity_join_requests", ["user_id"], :name => "index_charity_join_requests_on_user_id"

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "donations", :force => true do |t|
    t.integer  "charity_id"
    t.string   "charity_name"
    t.integer  "user_id"
    t.string   "user_name"
    t.text     "user_billing_address"
    t.datetime "date"
    t.string   "stripe_charge_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "amount_pennies",           :default => 0,     :null => false
    t.string   "amount_currency",          :default => "GBP", :null => false
    t.boolean  "paid"
    t.boolean  "refunded"
    t.string   "failure_message"
    t.string   "failure_code"
    t.integer  "amount_refunded_pennies",  :default => 0,     :null => false
    t.string   "amount_refunded_currency", :default => "GBP", :null => false
    t.integer  "application_fee_pennies",  :default => 0,     :null => false
    t.string   "application_fee_currency", :default => "GBP", :null => false
    t.integer  "gateway_fee_pennies",      :default => 0,     :null => false
    t.string   "gateway_fee_currency",     :default => "GBP", :null => false
  end

  add_index "donations", ["charity_id"], :name => "index_donations_on_charity_id"
  add_index "donations", ["user_id"], :name => "index_donations_on_user_id"

  create_table "editors_projects", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "faqs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

  add_index "faqs", ["project_id"], :name => "index_faqs_on_project_id"

  create_table "favorites", :force => true do |t|
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "go_cardless_merchants", :force => true do |t|
    t.integer  "charity_id"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "merchant_id"
  end

  add_index "go_cardless_merchants", ["charity_id"], :name => "index_go_cardless_merchants_on_charity_id"

  create_table "invitations", :force => true do |t|
    t.text     "text"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "project_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
  end

  add_index "invitations", ["project_id"], :name => "index_invitations_on_project_id"
  add_index "invitations", ["receiver_id"], :name => "index_invitations_on_receiver_id"
  add_index "invitations", ["sender_id"], :name => "index_invitations_on_sender_id"

  create_table "lifestyle_checkouts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer  "price_pennies",              :default => 0,         :null => false
    t.string   "price_currency",             :default => "GBP",     :null => false
    t.string   "inactive_icon_file_name"
    t.string   "inactive_icon_content_type"
    t.integer  "inactive_icon_file_size"
    t.datetime "inactive_icon_updated_at"
    t.string   "color",                      :default => "#000000"
  end

  create_table "make_change_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "makes", :force => true do |t|
    t.string   "name"
    t.string   "sanitized_name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer  "make_change_category_id"
  end

  add_index "makes", ["make_change_category_id"], :name => "index_makes_on_make_change_category_id"

  create_table "media", :force => true do |t|
    t.integer  "mediable_id"
    t.string   "mediable_type"
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "past_experience_photos", :force => true do |t|
    t.integer  "project_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "past_experience_photos", ["project_id"], :name => "index_past_experience_photos_on_project_id"

  create_table "project_donations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "projects_make_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "amount_pennies",   :default => 0,     :null => false
    t.string   "amount_currency",  :default => "GBP", :null => false
    t.string   "stripe_charge_id"
    t.boolean  "gift_aid",         :default => false
    t.integer  "project_id"
    t.boolean  "paid"
  end

  add_index "project_donations", ["project_id"], :name => "index_project_donations_on_project_id"
  add_index "project_donations", ["projects_make_id"], :name => "index_project_donations_on_projects_make_id"
  add_index "project_donations", ["user_id"], :name => "index_project_donations_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "problem"
    t.text     "solution"
    t.integer  "leader_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "charity_id"
    t.string   "slug"
    t.string   "help_image_file_name"
    t.string   "help_image_content_type"
    t.integer  "help_image_file_size"
    t.datetime "help_image_updated_at"
    t.string   "make_image_file_name"
    t.string   "make_image_content_type"
    t.integer  "make_image_file_size"
    t.datetime "make_image_updated_at"
    t.boolean  "budget_confirmation",     :default => false
    t.boolean  "approved",                :default => false
    t.boolean  "is_funded",               :default => false
    t.string   "help_statement"
    t.string   "beneficiaries"
    t.boolean  "draft",                   :default => true,  :null => false
    t.text     "activities"
    t.string   "change_statement"
    t.text     "past_experience"
    t.text     "url"
    t.string   "location"
  end

  add_index "projects", ["charity_id"], :name => "index_projects_on_charity_id"
  add_index "projects", ["leader_id"], :name => "index_projects_on_leader_id"
  add_index "projects", ["slug"], :name => "index_projects_on_slug", :unique => true

  create_table "projects_changes", :force => true do |t|
    t.integer  "project_id"
    t.integer  "change_id"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projects_changes", ["change_id"], :name => "index_projects_changes_on_change_id"
  add_index "projects_changes", ["project_id"], :name => "index_projects_changes_on_project_id"

  create_table "projects_makes", :force => true do |t|
    t.integer  "project_id"
    t.integer  "make_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "cost_pennies",  :default => 0,     :null => false
    t.string   "cost_currency", :default => "GBP", :null => false
    t.string   "intent",        :default => "",    :null => false
  end

  add_index "projects_makes", ["make_id"], :name => "index_projects_makes_on_make_id"
  add_index "projects_makes", ["project_id"], :name => "index_projects_makes_on_project_id"

  create_table "projects_reporters", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "projects_sub_causes", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "sub_cause_id"
  end

  add_index "projects_sub_causes", ["project_id"], :name => "index_projects_sub_causes_on_project_id"
  add_index "projects_sub_causes", ["sub_cause_id"], :name => "index_projects_sub_causes_on_sub_cause_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "shopping_cart_items", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "quantity"
    t.integer  "item_id"
    t.string   "item_type"
    t.float    "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shopping_carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stories", :force => true do |t|
    t.text     "text"
    t.integer  "change_id"
    t.integer  "project_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.string   "number"
    t.boolean  "approved",           :default => false
  end

  add_index "stories", ["change_id"], :name => "index_stories_on_change_id"
  add_index "stories", ["project_id"], :name => "index_stories_on_project_id"

  create_table "stripe_customers", :force => true do |t|
    t.integer  "user_id"
    t.string   "customer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "charity_id"
  end

  add_index "stripe_customers", ["charity_id"], :name => "index_stripe_customers_on_charity_id"
  add_index "stripe_customers", ["user_id"], :name => "index_stripe_customers_on_user_id"

  create_table "stripe_merchants", :force => true do |t|
    t.integer  "charity_id"
    t.string   "access_token"
    t.string   "publishable_key"
    t.string   "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "token_type"
    t.string   "scope"
    t.string   "livemode"
    t.string   "refresh_token"
  end

  add_index "stripe_merchants", ["charity_id"], :name => "index_stripe_merchants_on_charity_id"

  create_table "sub_causes", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.integer  "cause_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "sub_causes", ["cause_id"], :name => "index_sub_causes_on_cause_id"

  create_table "subscription_projects", :force => true do |t|
    t.integer  "project_id"
    t.integer  "subscription_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "amount_pennies",  :default => 0,     :null => false
    t.string   "amount_currency", :default => "GBP", :null => false
    t.boolean  "gift_aid",        :default => false
  end

  add_index "subscription_projects", ["project_id"], :name => "index_subscription_projects_on_project_id"
  add_index "subscription_projects", ["subscription_id"], :name => "index_subscription_projects_on_subscription_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "charity_id"
    t.integer  "user_id"
    t.string   "interval"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "stripe_customer_id"
    t.string   "stripe_subscription_status", :default => "inactive"
    t.integer  "application_fee_percent"
  end

  add_index "subscriptions", ["charity_id"], :name => "index_subscriptions_on_charity_id"
  add_index "subscriptions", ["stripe_customer_id"], :name => "index_subscriptions_on_stripe_customer_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "top_ups", :force => true do |t|
    t.integer  "topupable_id"
    t.string   "topupable_type"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "top_ups", ["user_id"], :name => "index_top_ups_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                      :default => "",   :null => false
    t.string   "encrypted_password",                         :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "neswletter_frequency_in_days"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "authentication_token"
    t.string   "facebook_token"
    t.string   "invitation_token",             :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "invitation_created_at"
    t.boolean  "intelligent_matching",                       :default => true
    t.string   "slug"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

  create_table "waiting_lists", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "welcome_messages", :force => true do |t|
    t.string   "headline"
    t.text     "text"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "project_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "welcome_messages", ["project_id"], :name => "index_welcome_messages_on_project_id"

end
