class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer :mediable_id
      t.string :mediable_type
      t.string :name

      t.timestamps
    end
  end
end
