FactoryGirl.define do
  factory :charity do
    ignore do
      leader nil
    end

    name "MyString"
    description "MyText"
    address "MyText"
    number "MyString"

    after(:build) do |charity, evaluator|
      leader = evaluator.leader || create(:user)
      charity.leader = leader
      charity.editors << leader
    end

    factory :charity_ready_for_approval do
      hmrc_number "MyHMRCNumber"
      charity_regulator CharityRegulators.none
      chv1 { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/document.pdf", 'application/pdf') }
      contract { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/document.pdf", 'application/pdf') }
      paying_in_slip { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/document.pdf", 'application/pdf') }

      factory :charity_approved do
        is_public true
      end
    end
  end

  factory :charity_without_leader, class: :charity do
    ignore do
      editor nil
    end

    name "MyString"
    description "MyText"
    address "MyText"
    number "MyString"

    after(:build) do |charity, evaluator|
      editor = evaluator.editor || create(:user)
      charity.editors << editor
    end
  end
end
