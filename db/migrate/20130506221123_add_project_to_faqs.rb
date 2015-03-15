class AddProjectToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :project_id, :integer
    add_index :faqs, :project_id
  end
end
