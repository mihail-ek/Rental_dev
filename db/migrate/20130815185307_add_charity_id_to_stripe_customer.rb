class AddCharityIdToStripeCustomer < ActiveRecord::Migration
  def change
    add_column :stripe_customers, :charity_id, :integer
    add_index :stripe_customers, :charity_id
  end
end
