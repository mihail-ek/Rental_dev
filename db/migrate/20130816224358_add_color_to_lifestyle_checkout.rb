class AddColorToLifestyleCheckout < ActiveRecord::Migration
  def change
    add_column :lifestyle_checkouts, :color, :string, default: '#000000'
  end
end
