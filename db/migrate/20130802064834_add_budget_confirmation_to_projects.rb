class AddBudgetConfirmationToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :budget_confirmation, :boolean, default: false
  end
end
