class MonetizeLifestyleCheckout < ActiveRecord::Migration
  def change
    add_money :lifestyle_checkouts, :price
  end
end
