# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :top_up do
    topupable_id 1
    topupable_type "MyString"
    user nil
  end
end
