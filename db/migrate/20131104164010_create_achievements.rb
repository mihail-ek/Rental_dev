class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.references :user
      t.references :project
      t.string :title
      t.text :text
      t.references :change
      t.string :number

      t.timestamps
    end
    add_index :achievements, :user_id
    add_index :achievements, :project_id
    add_index :achievements, :change_id
  end
end
