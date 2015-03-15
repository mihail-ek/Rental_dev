class AddStripeCustomerToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_customer_id, :integer
    add_index :subscriptions, :stripe_customer_id
  end
end
