class RemoveSubscriptionFromStripeCustomer < ActiveRecord::Migration
  def up
    remove_column :stripe_customers, :subscription_id
  end

  def down
    add_column :stripe_customers, :subscription_id, :integer
    add_index :stripe_customers, :subscription_id
  end
end
