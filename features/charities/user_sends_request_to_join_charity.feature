Feature: User sends request to join charity
  In order to become a member of a registered charity
  A user
  Should be able to send a join request

  @selenium @javascript
  Scenario: Signed in user sends request to join a registered charity
    Given I exist as a user
    And the charity I'm registering already exists
    When I am signed in
    And I go to the Charity Sign Up page
    And I go to the next page
    And I submit my charity registration number
    And I send a request to join the charity
    Then I should see that my request was sent

  @wip
  @selenium @javascript
  Scenario: Signed in user sends request to join a registered charity and all charity admins receive a live notification
    Given I exist as a user
    And the charity I'm registering already exists
    When the charity admin is signed in in his browser
    And I am signed in in my browser
    And I go to the Charity Sign Up page
    And I go to the next page
    And I submit my charity registration number
    And I send a request to join the charity
    Then I should see that my request was sent
    And the charity admin should see there are pending Join Requests in his browser
