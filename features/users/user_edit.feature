Feature: Edit User
  As a registered user of the website
  I want to edit my user profile
  so I can change my username

  @wip
  Scenario: I sign in and edit my account
    Given I am signed in
    When I edit my account details
    Then I should see an account edited message
