Feature: Charity Admin manages request to join charity
  In order to add a new charity member
  A Charity Admin
  Should be able to approve or reject a join request

  Background:
    Given there's a pending Charity Join Request

  @selenium @javascript
  Scenario: Charity Admin approves request to join a registered charity
    Given I am signed in
    And I am on the new staff approvals page
    When I approve the pending Join Request
    Then I should see that the pending Join Request disappears
    And I should see that the Join Request was approved

  @wip
  @selenium @javascript
  Scenario: Charity Admin approves request to join a registered charity and all charity admins receive a live notification
    Given another charity admin is signed in in his browser
    And I am signed in in my browser
    And I am on the new staff approvals page
    When I approve the pending Join Request
    Then I should see that the pending Join Request disappears
    And I should see that the Join Request was approved
    And the other charity admin should see that the Join Request was approved in his browser

  @selenium @javascript
  Scenario: Charity Admin rejects request to join a registered charity
    Given I am signed in
    And I am on the new staff approvals page
    When I reject the pending Join Request
    Then I should see that the pending Join Request disappears
    And I should see that the Join Request was rejected
