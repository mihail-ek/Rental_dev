# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_merchant do
    charity nil
    access_token "MyString"
    publishable_key "MyString"
    user_id "MyString"
  end
end
