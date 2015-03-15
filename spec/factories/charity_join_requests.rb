FactoryGirl.define do
  factory :charity_join_request do
    user
    charity
    message "My request message"

    factory :approved_charity_join_request do
      status 'approved'
      association :admin, factory: :user
    end

    factory :rejected_charity_join_request do
      status 'rejected'
      association :admin, factory: :user
    end
  end
end
