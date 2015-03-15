class LifestyleCheckout < ActiveRecord::Base
  default_scope order(:price_pennies)

  attr_accessible :name, :color

  attr_accessible :icon
  has_attached_file :icon,
                    :styles => { icon: "110x83#" },
                    :path => "lifestyle_checkouts/:id/icon/:style/:filename",
                    :default_url => '/assets/lifestyle_checkouts/icons/:style/missing.png'
  validates_attachment_content_type :icon, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
  
  attr_accessible :inactive_icon
  has_attached_file :inactive_icon,
                    :styles => { icon: "110x83#" },
                    :path => "lifestyle_checkouts/:id/inactive_icon/:style/:filename",
                    :default_url => 'assets/lifestyle_checkouts/inactive_icons/:style/missing.png'
  validates_attachment_content_type :inactive_icon, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  attr_accessible :price_pennies, :price_currency
  monetize :price_pennies
end
