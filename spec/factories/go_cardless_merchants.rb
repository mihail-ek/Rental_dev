# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :go_cardless_merchant do
    charity nil
    access_token "MyString"
  end
end
