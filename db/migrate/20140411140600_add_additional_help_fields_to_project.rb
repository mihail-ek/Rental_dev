class AddAdditionalHelpFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :help_statement, :string
    add_column :projects, :beneficiaries, :string
  end
end
