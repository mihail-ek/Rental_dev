class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :charity
      t.string :charity_name
      t.references :user
      t.string :user_name
      t.text :user_billing_address
      t.datetime :date
      t.boolean :gift_aid
      t.string :status
      t.string :stripe_charge_id

      t.timestamps
    end
    add_index :donations, :charity_id
    add_index :donations, :user_id
  end
end
