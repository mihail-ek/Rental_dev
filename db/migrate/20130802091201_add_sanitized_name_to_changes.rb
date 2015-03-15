class AddSanitizedNameToChanges < ActiveRecord::Migration
  def change
    add_column :changes, :sanitized_name, :string
  end
end
