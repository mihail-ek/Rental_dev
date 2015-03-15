class ShoppingCartItem < ActiveRecord::Base
  acts_as_shopping_cart_item
  attr_accessible :item, :price, :quantity
end
