object @join_request
attributes :id
node :user_name do |join_request|
  join_request.user.name
end
node :admin_name do |join_request|
  join_request.admin.name
end
node :charity_name do |join_request|
  join_request.charity.name
end
