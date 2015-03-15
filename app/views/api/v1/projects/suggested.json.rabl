object @project
attributes :id, :name, :path, :change_score, :problem, :solution
node :top_ups_count do |project|
  project.top_ups.count
end
node :makers_count do |project|
  project.makers.count
end
node :top_ups_count do |project|
  project.top_ups.count
end
node :followers_count do |project|
  project.followers.count
end
node :image_alt do |project|
  project.help_image_file_name
end
node :image_url do |project|
  project.help_image(:to_add)
end
node :image_for_you_might_like_url do |project|
  project.help_image(:you_might_like)
end
node :has_intelligent_matching do |project|
  false
end
node :make_icon do |project|
  if project.current_project_make
    asset_path project.current_project_make.make.icon(:square)
  elsif project.previous_project_make
    asset_path project.previous_project_make.make.icon(:square)
  else
    asset_path "sprites/icons/seeds.png"
  end
end
node :progress do |project|
  if project.current_project_make
    project.current_project_make.progress
  elsif project.previous_project_make
    progress = project.previous_project_make.progress
  else
    progress = 0
  end
end
node :change_icon do |project|
  if project.current_project_change
    asset_path project.current_project_change.change.icon(:small)
  elsif project.previous_project_change
    asset_path project.previous_project_change.change.icon(:small)
  end
end
node :change_count do |project|
  if project.current_project_change
    project.current_project_change.changes_total
  elsif project.previous_project_change
    project.previous_project_change.changes_total
  end
end
