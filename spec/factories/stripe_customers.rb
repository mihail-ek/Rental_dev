# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_customer do
    user nil
    customer_id "MyString"
  end
end
