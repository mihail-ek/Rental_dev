class AddApprovedToStories < ActiveRecord::Migration
  def change
    add_column :stories, :approved, :boolean, default: false
  end
end
