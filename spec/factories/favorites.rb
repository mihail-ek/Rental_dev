# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favorite do
    favoritable_id 1
    favoritable_type "MyString"
    user nil
  end
end
