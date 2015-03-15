FactoryGirl.define do
  factory :cause do
    sequence(:name) { |n| "Cause #{n}" }

    factory :cause_with_sub_cause do
      after(:build) do |cause|
        cause.sub_causes << create(:sub_cause)
      end
    end
  end
end
