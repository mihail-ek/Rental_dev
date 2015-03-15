class StripeMerchant < ActiveRecord::Base
  belongs_to :charity
  attr_accessible :access_token, :publishable_key, :user_id
end
