# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :achievement do
    user nil
    project nil
    title "MyString"
    text "MyText"
    change nil
    number "MyString"
  end
end
