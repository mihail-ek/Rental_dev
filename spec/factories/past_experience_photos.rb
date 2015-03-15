FactoryGirl.define do
  factory :past_experience_photo do
    project
    photo { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }
  end
end
