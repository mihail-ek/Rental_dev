class CreateCharityJoinRequests < ActiveRecord::Migration
  def change
    create_table :charity_join_requests do |t|
      t.references :user
      t.references :charity
      t.text :message, limit: 300
      t.string :status, null: false
      t.integer :admin_id

      t.timestamps
    end
    add_index :charity_join_requests, :user_id
    add_index :charity_join_requests, :charity_id
    add_index :charity_join_requests, :admin_id
  end
end
