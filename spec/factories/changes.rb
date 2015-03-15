FactoryGirl.define do
  factory :change do
    sequence(:name) { |n| "Change #{n}" }
    sequence(:sanitized_name) { |n| "Change #{n}" }
    make_change_category
    icon { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }
  end
end
