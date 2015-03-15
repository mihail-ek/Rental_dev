FactoryGirl.define do
  factory :project do
    ignore do
      charity nil
    end

    headline "MyHeadline"
    help_description "MyHelpDescription"
    make_statement "MyMakeStatement"
    budget_confirmation true

    after(:build) do |project, evaluator|
      project.charity = evaluator.charity || create(:charity_approved)
      project.causes << (Cause.first || create(:cause))
      project.projects_makes << create(:projects_make, project: project)
      project.projects_changes << create(:projects_change, project: project)
    end

    factory :project_ready_for_approval do
      help_statement "Some statement"
      beneficiaries "Someone"
      problem_list "some tag, another one"
      problem_statistic_list "some tag, another one"
      help_image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }
      tag_list "some tag,another one"

      make_statement "Some make statement"
      activities "Some activities"
      make_image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png') }
      method_list "some related theme,another theme"

      change_statement 'Some change statement'
      change_tag_list 'Some change tag'
      past_experience 'Some experience'
      past_experience_photos [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png')]

      location "Some location"

      after(:build) do |project, evaluator|
        project.leader = (project.charity.leader || create(:user))
        project.editors << (project.charity.leader || create(:user))
        project.reporters << (project.charity.leader || create(:user))
        project.welcome_messages << create(:welcome_message)
      end

      factory :project_approved do
        approved true
      end
    end
  end

  factory :project_without_charity, class: Project do
    headline "MyHeadline"
    help_description "MyHelpDescription"
    make_statement "MyMakeDescription"
    budget_confirmation true
  end
end
