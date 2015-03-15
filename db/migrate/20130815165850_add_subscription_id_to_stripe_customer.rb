class AddSubscriptionIdToStripeCustomer < ActiveRecord::Migration
  def change
    add_column :stripe_customers, :subscription_id, :integer
    add_index :stripe_customers, :subscription_id
  end
end
