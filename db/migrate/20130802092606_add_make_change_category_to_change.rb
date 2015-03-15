class AddMakeChangeCategoryToChange < ActiveRecord::Migration
  def change
    add_column :changes, :make_change_category_id, :integer
    add_index :changes, :make_change_category_id
  end
end
