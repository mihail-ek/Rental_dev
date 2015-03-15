class AddChangeAttributesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :change_statement, :string
    add_column :projects, :past_experience, :text
  end
end
