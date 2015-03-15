class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :charity
      t.references :project
      t.references :user
      t.string :interval

      t.timestamps
    end
    add_index :subscriptions, :charity_id
    add_index :subscriptions, :project_id
    add_index :subscriptions, :user_id
  end
end
