class AddHmrcNumberToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :hmrc_number, :string
  end
end
