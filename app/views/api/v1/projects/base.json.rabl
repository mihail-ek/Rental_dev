attributes :id, :name, :path, :edit_path, :update_path
node :image_url do |project|
  project.help_image(:square)
end
