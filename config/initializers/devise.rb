Devise.setup do |config|

  config.secret_key = '427c2d0638fec6ef84970ecb15e0abe53d6496c187ab3807d137a3056565312842ecacfff48c0a758c793f0aa1723eac1f23b75442e61528c7315adea1f78c8e'

  require "omniauth-facebook"
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
  config.omniauth :facebook, "418680344889116", "250430a2b16deaf6730e6a573a7530d0"
  config.omniauth :twitter, "wGd8aFqklbNmZIk7fTkKw", "uyFk7oVw9qbIxJDOEXlOjMnE3Z5vky1hLOkk2Of1e8"

  # ==> Configuration for :invitable
  # Doc: https://github.com/scambra/devise_invitable
  config.invitation_limit = 2

  config.mailer_sender = "Makerble team <team@makerble.com>"

  config.mailer = "DeviseMailer"

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [ :email ]

  config.strip_whitespace_keys = [ :email ]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = true

  config.password_length = 6..128

  config.reset_password_within = 6.hours

  config.sign_out_via = Rails.env.test? ? :get : :delete
end
