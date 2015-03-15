class AddProjectToWelcomeMessage < ActiveRecord::Migration
  def change
    add_column :welcome_messages, :project_id, :integer
    add_index :welcome_messages, :project_id
  end
end
