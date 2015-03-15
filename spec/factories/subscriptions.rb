# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    charity nil
    project nil
    user nil
    interval "MyString"
  end
end
