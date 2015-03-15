class MonetizeDonations < ActiveRecord::Migration
  def change
    add_money :donations, :amount
    add_money :donations, :fee
  end
end
