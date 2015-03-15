# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    text "MyText"
    sender_id 1
    receiver_id 1
    project nil
  end
end
