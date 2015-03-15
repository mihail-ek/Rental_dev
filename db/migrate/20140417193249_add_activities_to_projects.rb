class AddActivitiesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :activities, :text
  end
end
