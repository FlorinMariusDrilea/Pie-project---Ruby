Feature: Edit Account Page

Scenario: Navigate to accounts page
    #Given I am on accounts page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Edit Account" within "#EditAccount"
    Then I should be on edit account page
    #Given I am on accounts page
    When I press "Back to Accounts" within "#BackToAccounts"
    Then I should be on accounts page

Scenario: Edit real users data
    #Given I am on accounts page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Edit Account" within "#EditAccount"
    Then I should be on edit account page
    #Given I am on accounts page
    When I fill in "getuser" with "testuser2" within "#UserEdit"
    When I press "Apply Changes" within "#UserEdit"
    Then I should see "Successfully updated account data"

Scenario: Edit data of a user that does not exist
    #Given I am on accounts page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Edit Account" within "#EditAccount"
    Then I should be on edit account page
    #Given I am on accounts page
    When I fill in "getuser" with "notarealuser" within "#UserEdit"
    When I press "Apply Changes" within "#UserEdit"
    Then I should see "User does not exist"