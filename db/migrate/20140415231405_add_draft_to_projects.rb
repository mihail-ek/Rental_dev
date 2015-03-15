class AddDraftToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :draft, :boolean, null: false, default: true
  end
end
