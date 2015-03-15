class CreateProjectsChanges < ActiveRecord::Migration
  def change
    create_table :projects_changes do |t|
      t.references :project
      t.references :change
      t.integer :number

      t.timestamps
    end
    add_index :projects_changes, :project_id
    add_index :projects_changes, :change_id
  end
end
