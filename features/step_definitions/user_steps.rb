### GIVEN ###
Given /^I am not signed in$/ do
  visit '/users/sign_out'
end

Given /^I am signed in$/ do
  create_user unless @user
  sign_in(@visitor)
end

Given /^I am signed in as admin$/ do
  create_admin
  sign_in(@visitor)
end

Given(/^another charity admin is signed in$/) do
  charity_admin_attributes = FactoryGirl.attributes_for(:user)
  charity_admin = FactoryGirl.create :user, email: charity_admin_attributes[:email]
  @charity.add_member charity_admin
  sign_in charity_admin_attributes
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in(@visitor)
end

When /^I sign in with my facebook account$/ do
  visit '/users/sign_in'
  click_on I18n.t('users.sessions.new.facebook')
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with my account$/ do
  create_visitor
  fill_in_sign_up_form(@visitor)
end

When /^I sign up with my facebook account$/ do
  click_on I18n.t('users.registrations.new.facebook')
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "changeme123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in(@visitor)
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in(@visitor)
end

When /^I edit my account details$/ do
  click_link "Edit account"
  fill_in "Name", :with => "newname"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/'
end

When(/^the charity admin is signed in$/) do
  sign_in(@charity_admin)
end

### THEN ###
Then /^I should be signed in$/ do
  # page.should have_content "Logout"
  page.should_not have_content I18n.t('layouts.header.sign_in')
end

Then /^I should be signed out$/ do
  page.should have_content I18n.t('layouts.header.sign_in')
  # page.should_not have_content "Logout"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I see a successful (\w+) authentication message$/ do |kind|
  page.should have_content I18n.t('devise.omniauth_callbacks.success', kind: kind)
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Emailis invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Passwordcan't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end
