Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

  Scenario: User is not signed up
    Given I do not exist as a user
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should be signed out

  Scenario: User signs in successfully via email
    Given I exist as a user
    And I am not signed in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I return to the site
    Then I should be signed in

  @omniauth_test
  Scenario: User signs in successfully via facebook
    Given I am not signed in
    When I sign in with my facebook account
    Then I see a successful Facebook authentication message
    When I return to the site
    Then I should be signed in

  Scenario: User enters wrong email
    Given I exist as a user
    And I am not signed in
    When I sign in with a wrong email
    Then I see an invalid login message
    And I should be signed out

  Scenario: User enters wrong password
    Given I exist as a user
    And I am not signed in
    When I sign in with a wrong password
    Then I see an invalid login message
    And I should be signed out
