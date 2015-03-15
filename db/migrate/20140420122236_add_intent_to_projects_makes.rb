class AddIntentToProjectsMakes < ActiveRecord::Migration
  def change
    add_column :projects_makes, :intent, :string, null: false, default: ''
  end
end
