attributes :id
node :user_name do |join_request|
  join_request.user.name
end
node :user_avatar_url do |join_request|
  join_request.user.avatar
end
