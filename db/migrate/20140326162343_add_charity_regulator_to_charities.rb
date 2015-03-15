class AddCharityRegulatorToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :charity_regulator, :string
  end
end
