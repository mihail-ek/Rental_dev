class StripeCustomer < ActiveRecord::Base
  belongs_to :user
  # Charity's customer (Makerble's customer if empty)
  belongs_to :charity
  has_many :subscriptions

  attr_accessible :customer_id # Stripe customer id
  attr_accessible :user_id, :charity_id, :subscription_ids

  def self.create_with_the_api(user, token)
    customer = Stripe::Customer.create(
      :email => user.email,
      :card  => token
    )

    StripeCustomer.create(customer_id: customer.id, user_id: user.id)
  end
end
