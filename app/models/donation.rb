class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :user
  attr_accessible :charity_name, :date, :stripe_charge_id,
    :user_billing_address, :user_name, :paid, :refunded,
    :failure_message, :failure_code, :charity_id, :user_id,
    :amount_pennies, :amount_refunded_pennies, :application_fee_pennies,
    :gateway_fee_pennies

  scope :paid, -> { where(paid: true) }

  monetize :amount_pennies
  monetize :amount_refunded_pennies
  monetize :application_fee_pennies
  monetize :gateway_fee_pennies
end
