def build_charity
  @charity ||= FactoryGirl.build :charity
end

def fill_required_fields
  build_charity
  fill_in "charity_name", :with => @charity.name
  fill_in "charity_description", :with => @charity.description
  fill_in "charity_address", :with => @charity.address
  fill_in "charity_number", :with => @charity.number
end

def fill_fields_required_for_approval
  fill_required_fields
  attach_document_to "charity_chv1"
  attach_document_to "charity_contract"
  attach_document_to "charity_paying_in_slip"
  fill_in "charity_hmrc_number", with: "2345"
end

Given(/^the charity I'm registering already exists$/) do
  @charity_admin = FactoryGirl.attributes_for :user
  @charity = FactoryGirl.create :charity, leader: User.create(@charity_admin)
end

Given(/^there's a pending Charity Join Request$/) do
  create_user
  @charity = FactoryGirl.create :charity, leader: @user
  @charity_join_request = FactoryGirl.create :charity_join_request, charity: @charity
end

When(/^I fill all required fields$/) do
  fill_required_fields
end

When(/^I submit with all required fields$/) do
  fill_required_fields
  click_on I18n.t("admin.form.save")
end

When(/^I submit with all fields required for approval$/) do
  fill_fields_required_for_approval
  click_on I18n.t("admin.form.save")
end

When(/^I fill all fields required for approval$/) do
  fill_fields_required_for_approval
end

When(/^I submit with public set to true$/) do
  check 'charity_is_public'
  click_on I18n.t("admin.form.save")
end

When(/^I sign in to my personal account$/) do
  click_on I18n.t('helpers.sign_in')
  fill_in_sign_in_form(@visitor)
end

When(/^I submit my charity registration number$/) do
  build_charity
  fill_in "charity_number", with: @charity.number
  click_button I18n.t('forms.actions.charity_registration.submit')
end

When(/^I submit my charity with valid data$/) do
  fill_in_charity_form(@charity)
end

When(/^I send a request to join the charity$/) do
  fill_in_charity_join_request_form
end

When(/^I skip project's creation$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.charity_created')
  click_on I18n.t('helpers.skip_project_creation')
end

When(/^I approve the pending Join Request$/) do
  first('.manage-join-request[data-action="approve"]').click
end

When(/^I reject the pending Join Request$/) do
  first('.manage-join-request[data-action="reject"]').click
end

Then(/^I should see the new charity on Pending Charities$/) do
  visit rails_admin.index_path(model_name: 'pending_charity')
  expect(page).to have_text @charity.name
end

Then(/^I should see the new charity on Approved Charities$/) do
  visit rails_admin.index_path(model_name: 'approved_charity')
  expect(page).to have_text @charity.name
end

Then(/^I should see an error message$/) do
  expect(page).to have_css('.alert.alert-error')
end

Then(/^I should see my charity$/) do
  expect(page).to have_text @charity.name
end

Then(/^I should see that my request was sent$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.charity_join_request_sent')
end

Then(/^the charity admin should see there are pending Join Requests$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.charity_join_request_received')
  expect(page).to have_css ".link-text[href='#{approvals_new_staff_url}']"
end

Then(/^I should see that the pending Join Request disappears$/) do
  expect(page).not_to have_css('.manage-join-request[data-action="approve"]')
end

Then(/^I should see that the Join Request was approved$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.charity_join_request_approved', requester: @charity_join_request.user.name, charity: @charity_join_request.charity.name, admin: @charity_join_request.reload.admin.name)
end

Then(/^the other charity admin should see that the Join Request was approved$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.charity_join_request_approved_generic')
end

Then(/^I should see that the Join Request was rejected$/) do
  expect(page).to have_text I18n.t('layouts.flash_messages.charity_join_request_rejected', requester: @charity_join_request.user.name, charity: @charity_join_request.charity.name)
end
