FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |i| "First Name #{i}" }
    sequence(:last_name) { |i| "Last Name #{i}" }
    sequence(:email) { |i| "user#{i}@example.com" }
    password 'changeme'
    password_confirmation 'changeme'

    after(:build) do |user|
      Role.find_or_create_by_name({ name: 'user' })
      user.add_role :user
    end
  end

  factory :admin, class: User do
    first_name "Text Admin"
    sequence(:last_name) { |i| i }
    sequence(:email) { |i| "admin#{i}@example.com" }
    password 'changeme'
    password_confirmation 'changeme'
    avatar { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }

    after(:build) do |user|
      Role.find_or_create_by_name({ name: 'admin' })
      user.add_role :admin
    end
  end
end
