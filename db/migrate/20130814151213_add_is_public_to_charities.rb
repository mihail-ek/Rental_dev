class AddIsPublicToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :is_public, :boolean, default: false
  end
end
