FactoryGirl.define do
  factory :projects_change do
    project
    number 1

    after(:build) do |projects_change|
      projects_change.change = Change.first || create(:change)
    end
  end
end
