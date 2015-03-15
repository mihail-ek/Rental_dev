class CreateTopUps < ActiveRecord::Migration
  def change
    create_table :top_ups do |t|
      t.integer :topupable_id
      t.string :topupable_type
      t.references :user

      t.timestamps
    end
    add_index :top_ups, :user_id
  end
end
