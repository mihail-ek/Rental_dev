@wip
Feature: Invitations
  In order to allow anyone to sign up
  A user
  Shouldn't be able to see nor perform any invitation actions

  Scenario: Signed in user follows the Get started link
    Given I am signed in
    When I click on Get Started
    Then I should be on the Get Started page

  Scenario: Signed out user follows the Get started link
    Given I am not signed in
    When I click on Get Started
    Then I should be on the sign in page

  Scenario: Signed out user can't see Request Invitation link
    Given I am not signed in
    Then I shouldn't see the Request Invitation link

  Scenario: Signed in user can't see Send Invitation link
    Given I am signed in
    And I'm not on the home page
    Then I shouldn't see the Send Invitation link
