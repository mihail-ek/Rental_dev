module FormSubmissionHelpers
  def fill_in_sign_in_form(visitor)
    fill_in "Email", with: visitor[:email]
    fill_in "Password", with: visitor[:password]

    click_button I18n.t('helpers.sign_in')
  end

  def fill_in_sign_up_form(visitor)
    fill_in "user_first_name", with: visitor[:first_name]
    fill_in "user_last_name", with: visitor[:last_name]
    fill_in "user_email", with: visitor[:email]
    fill_in "user_password", with: visitor[:password]
    fill_in "user_password_confirmation", with: visitor[:password_confirmation]

    click_button I18n.t('forms.actions.sign_up.submit')
  end

  def fill_in_charity_form(charity)
    fill_in "charity_name", with: charity.name
    fill_in "charity_description", with: charity.description
    fill_in "charity_address", with: charity.address

    click_button I18n.t('helpers.submit.create', model: 'Charity')
  end

  def fill_in_charity_join_request_form
    click_button I18n.t('helpers.submit.charity_join_request.create')
  end

  def attach_image_to(input)
    file_path = "#{Rails.root}/spec/fixtures/default.png"
    if input.is_a? String
      attach_file input, file_path
    else
      input.set file_path
    end
  end

  def attach_document_to(input)
    file_path = "#{Rails.root}/spec/fixtures/document.pdf"
    attach_file input, file_path
  end

  def fill_in_help_form(project)
    fill_in "project_help_statement", with: project.help_statement
    fill_in "project_help_description", with: project.help_description
    fill_in "project_beneficiaries", with: project.beneficiaries
    find(".project_problem_list .select2-input").set project.problem_list.join(',').concat(',')
    find(".project_problem_statistic_list .select2-input").set project.problem_statistic_list.join(',').concat(',')
    find(".project_tag_list .select2-input").set project.tag_list.join(',').concat(',')
    cause_id = project.causes.first.id
    find("#project_cause_ids_#{cause_id}").click
    find("#s2id_project_cause_sub_causes_#{cause_id}_sub_cause_list .select2-input").set 'some sub cause,'
  end

  def fill_in_make_form(project)
    fill_in "project_make_statement", with: project.make_statement
    fill_in "project_activities", with: project.activities
    within('#makes') do
      first('.add_fields').click
      first('select[id$="_make_id"]').select(project.projects_makes.first.make.name)
      first('input[id$="_cost"]').set project.projects_makes.first.cost
      first('input[id$="_intent"]').set project.projects_makes.first.intent
    end
    find(".project_method_list .select2-input").set project.method_list.join(',').concat(',')
    find('#project_budget_confirmation').set true
  end

  def fill_in_change_form(project)
    fill_in "project_change_statement", with: project.change_statement
    within('#changes') do
      first('.add_fields').click
      first('select[id$="_change_id"]').select(project.projects_changes.first.change.name)
      first('input[id$="_number"]').set project.projects_changes.first.number
    end
    find(".project_change_tag_list .select2-input").set project.change_tag_list.join(',').concat(',')
    fill_in "project_past_experience", with: project.past_experience
    attach_image_to "project_past_experience_photos"
  end

  def fill_in_more_info_form(project)
    fill_in 'project_headline', with: project.headline
    fill_in 'project_location', with: project.location
    within('#welcome_messages') do
      first('input[id$="_headline"]').set project.welcome_messages.first.headline
      attach_image_to first('input[id$="_image"]')
      first('textarea[id$="_text"]').set project.welcome_messages.first.text
    end
    find(".project_reporters .select2-input").set project.reporters.first.name.concat(',')
    within('#faqs') do
      first('.add_fields').click
      first('input[id$="_question"]').set 'Some question'
      first('textarea[id$="_answer"]').set 'Some answer'
    end
  end
end

World(FormSubmissionHelpers)
