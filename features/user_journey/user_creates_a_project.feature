Feature: User creates a project
  In order to promote a charity's project
  A user
  Should be able to create a project just after registering a charity

  Background:
    Given there are causes in the system
    Given there are make items in the system
    Given there are change items in the system
    And I am signed in
    When I go to the Charity Sign Up page
    And I go to the next page
    And I submit my charity registration number
    And I submit my charity with valid data

  @javascript @selenium
  Scenario: User fills only one section and saves the project
    When I fill in the Project Help form
    And I click on Save Project
    Then I should see a project saved message
    When I go to the Current Status Dashboard page
    Then I should see my project's draft

  @javascript @selenium
  Scenario: User fills all project's sections submitting the project for approval
    When I fill in the Project Help form
    And I advance to the next section
    When I fill in the Project Make form
    And I advance to the next section
    When I fill in the Project Change form
    And I advance to the next section
    When I fill in the Project More Info form
    And I advance to the next section
    And I submit the project for approval
    Then I should see a project submitted for approval message
    When I go to the Current Status Dashboard page
    Then I should see my project is pending approval
