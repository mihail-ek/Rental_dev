attributes :id, :name, :price_pennies, :color
node :icon do |item|
  item.icon(:icon)
end
node :inactive_icon do |item|
  item.inactive_icon(:icon)
end
