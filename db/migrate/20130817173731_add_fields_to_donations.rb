class AddFieldsToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :paid, :boolean
    add_column :donations, :refunded, :boolean
    add_column :donations, :failure_message, :string
    add_column :donations, :failure_code, :string
    add_money :donations, :amount_refunded
  end
end
