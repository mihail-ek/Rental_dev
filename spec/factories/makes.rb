FactoryGirl.define do
  factory :make do
    sequence(:name) { |n| "Make #{n}" }
    sequence(:sanitized_name) { |n| "Make #{n}" }
    make_change_category
    icon { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }
  end
end
