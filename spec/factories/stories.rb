FactoryGirl.define do
  factory :story do
    text "MyText"
    number "MyNumber"
    change
    project
  end
end
