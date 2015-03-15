FactoryGirl.define do
  factory :welcome_message do
    headline "My Welcome Message"
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }
    text "My Welcome Text"
    project
  end
end
