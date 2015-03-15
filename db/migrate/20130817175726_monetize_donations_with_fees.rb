class MonetizeDonationsWithFees < ActiveRecord::Migration
  def change
    remove_money :donations, :fee
    add_money :donations, :application_fee
    add_money :donations, :gateway_fee
  end
end
