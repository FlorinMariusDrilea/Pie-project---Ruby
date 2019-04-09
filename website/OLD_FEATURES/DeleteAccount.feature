Feature: Delete Account Page

Scenario: Navigate to accounts page
    # Given I am on delete page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Delete Account" within "#DeleteAccount"
    Then I should be on delete account page
    # Given I am on delete page
    When I press "Back to Accounts" within "#BackToAccounts"
    Then I should be on accounts page

Scenario: Delete real user
    # Given I am on delete page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Delete Account" within "#DeleteAccount"
    Then I should be on delete account page
    # Given I am on delete page
    When I fill in "getuser" with "testuser1" within "#UserDelete"
    When I press "Delete" within "#UserDelete"
    Then I should see "Successfully deleted account"

Scenario: Delete user that does not exist
    # Given I am on delete page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Delete Account" within "#DeleteAccount"
    Then I should be on delete account page
    # Given I am on delete page
    When I fill in "getuser" with "notarealuser"
    When I press "Delete" within "#UserDelete"
    Then I should see "User does not exist"