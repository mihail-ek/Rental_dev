class ProjectsReportersJoinTable < ActiveRecord::Migration
  def up
    create_table :projects_reporters, { :id => false } do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
    end
  end

  def down
    drop_table :projects_reporters
  end
end
