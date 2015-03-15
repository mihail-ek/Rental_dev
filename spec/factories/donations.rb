# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donation do
    charity nil
    charity_name "MyString"
    user nil
    user_name "MyString"
    user_billing_address "MyText"
    date "2013-08-17 17:04:26"
    gift_aid false
    status "MyString"
    sstripe_charge_id "MyString"
  end
end
