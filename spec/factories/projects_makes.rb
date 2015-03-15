FactoryGirl.define do
  factory :projects_make do
    project
    cost 1
    intent 'Some intent'

    after(:build) do |projects_make|
      projects_make.make = Make.first || create(:make)
    end
  end
end
