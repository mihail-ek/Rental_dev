class GoCardlessMerchant < ActiveRecord::Base
  belongs_to :charity
  attr_accessible :access_token, :merchant_id, :charity_id
end
