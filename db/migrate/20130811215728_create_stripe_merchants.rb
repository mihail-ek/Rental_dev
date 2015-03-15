class CreateStripeMerchants < ActiveRecord::Migration
  def change
    create_table :stripe_merchants do |t|
      t.references :charity
      t.string :access_token
      t.string :publishable_key
      t.string :user_id

      t.timestamps
    end
    add_index :stripe_merchants, :charity_id
  end
end
