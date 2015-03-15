class AddStripeSubscriptionStatusToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription_status, :string, default: 'inactive'
  end
end
