class AddEditorsAndReportersToProjects < ActiveRecord::Migration
  def up
    create_table :editors_projects, { :id => false } do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
    end
    drop_table :colleagues_projects
  end

  def down
    drop_table :editors_projects
    create_table :colleagues_projects, { :id => false } do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
    end
  end
end
