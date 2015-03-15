class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text :text
      t.references :change
      t.references :project

      t.timestamps
    end
    add_index :stories, :change_id
    add_index :stories, :project_id
  end
end
