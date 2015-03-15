FactoryGirl.define do
  factory :make_change_category do
    sequence(:name) { |n| "Category #{n}" }
  end
end
