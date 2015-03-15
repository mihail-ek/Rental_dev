Feature: User registers charity for approval
  In order to have a charity in the system
  A user
  Should be able to register a charity

  Background:
    Given I am on the home page

  Scenario: Signed out, but already registered, user registers a new charity
    Given I exist as a user
    And I am not signed in
    When I go to the Charity Sign Up page
    And I go to the next page
    And I sign in to my personal account
    And I submit my charity registration number
    And I submit my charity with valid data
    And I skip project's creation
    Then I should see my charity

  Scenario: Signed in user registers a new charity
    Given I exist as a user
    And I am signed in
    When I go to the Charity Sign Up page
    And I go to the next page
    And I submit my charity registration number
    And I submit my charity with valid data
    And I skip project's creation
    Then I should see my charity

  Scenario: Unregistered user registers a new charity, by first signing up with email
    Given I am not signed in
    When I go to the Charity Sign Up page
    And I go to the next page
    And I sign up with my account
    And I submit my charity registration number
    And I submit my charity with valid data
    And I skip project's creation
    Then I should see my charity

  @omniauth_test
  Scenario: Unregistered user registers a new charity, by first signing up with facebook
    Given I am not signed in
    When I go to the Charity Sign Up page
    And I go to the next page
    And I sign up with my facebook account
    And I submit my charity registration number
    And I submit my charity with valid data
    And I skip project's creation
    Then I should see my charity
