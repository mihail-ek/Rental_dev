class CreateStripeCustomers < ActiveRecord::Migration
  def change
    create_table :stripe_customers do |t|
      t.references :user
      t.string :customer_id

      t.timestamps
    end
    add_index :stripe_customers, :user_id
  end
end
