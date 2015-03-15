class CreateProjectsMakes < ActiveRecord::Migration
  def change
    create_table :projects_makes do |t|
      t.references :project
      t.references :make

      t.timestamps
    end
    add_index :projects_makes, :project_id
    add_index :projects_makes, :make_id
  end
end
