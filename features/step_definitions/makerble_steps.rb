Given(/^I am on the add new charity page in master admin panel$/) do
  visit rails_admin.new_path(model_name: 'charity')
end

Given(/^I am on the home page$/) do
  visit root_path
end

Given(/^I'm not on the home page$/) do
  visit causes_preferences_causes_path
end

Given(/^there are causes in the system$/) do
  FactoryGirl.create_list :cause_with_sub_cause, 2
end

Given(/^there are make items in the system$/) do
  FactoryGirl.create_list :make, 2
end

Given(/^there are change items in the system$/) do
  FactoryGirl.create_list :change, 2
end

Given(/^I am on the new staff approvals page$/) do
  visit approvals_new_staff_path
end

When(/^I click on Get Started$/) do
  first('.call-to-action').click
end

When(/^I go to the Charity Sign Up page$/) do
  click_on I18n.t('layouts.header.charity_sign_up')
end

When(/^I go to the Current Status Dashboard page$/) do
  click_on I18n.t('layouts.header.charity_dashboard')
end

When(/^I go to the next page$/) do
  click_on I18n.t('helpers.next')
end

When(/^I am in (.*) browser$/) do |name|
  Capybara.session_name = name
end

When(/^(?!I am in)(.*(?= in)) in (.*) browser$/) do |step, browser_name|
  step "I am in #{browser_name} browser"
  step step
end

Then(/^I should be on the sign in page$/) do
  expect(current_path).to eq new_user_session_path
end

Then(/^I shouldn't see the Request Invitation link$/) do
  expect(page).not_to have_text I18n.t('layouts.header.request_invitation')
end

Then(/^I should be on the Get Started page$/) do
  expect(current_path).to eq causes_preferences_causes_path
end

Then(/^I shouldn't see the Send Invitation link$/) do
  expect(page).not_to have_text I18n.t('layouts.header.send_invitation')
end
