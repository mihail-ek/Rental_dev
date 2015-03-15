Feature: Admin adds charity
  In order to start a charity's registration process
  An admin
  Should be able to create a new charity

  Background:
    Given I am signed in as admin
    And I am on the add new charity page in master admin panel

  Scenario: Adds pending approval charity
    When I submit with all required fields
    Then I should see the new charity on Pending Charities

  Scenario: Adds charity ready for approval
    When I submit with all fields required for approval
    Then I should see the new charity on Pending Charities

  Scenario: Tries to add an approved charity that is not ready for approval
    When I fill all required fields
    And I submit with public set to true
    Then I should see an error message

  Scenario: Adds an approved charity
    When I fill all fields required for approval
    And I submit with public set to true
    Then I should see the new charity on Approved Charities
