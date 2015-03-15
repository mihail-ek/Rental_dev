class AddCharityToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :charity_id, :integer
    add_index :projects, :charity_id
  end
end
