When(/^I fill in the one page project form$/) do
  @project ||= FactoryGirl.build :project_ready_for_approval
  fill_in_help_form(@project)
  fill_in_make_form(@project)
  fill_in_change_form(@project)
  fill_in_more_info_form(@project)
end

When(/^I fill in the Project (.+?) form$/) do |form_type|
  @project ||= FactoryGirl.build :project_ready_for_approval
  form_type = form_type.downcase.gsub(' ', '_')
  send "fill_in_#{form_type}_form".to_sym, @project
end

When(/^I advance to the next section$/) do
  find('.next-section').click
end

When(/^I click on Save Project$/) do
  click_button I18n.t('helpers.submit.submit', model: 'Project')
end

When(/^I submit the project for approval$/) do
  click_button I18n.t('forms.actions.projects.submit_for_approval')
end

Then(/^I should see a project saved message$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.project_saved')
end

Then(/^I should see a project submitted for approval message$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.project_submitted')
end

Then(/^I should see my project's draft$/) do
  message = I18n.t('helpers.draft')
  page.body.should match(%r{#{message}}i)
end

Then(/^I should see my project is pending approval$/) do
  message = I18n.t('helpers.pending_approval')
  page.body.should match(%r{#{message}}i)
end
