class AddIsFundedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_funded, :boolean, default: false
  end
end
