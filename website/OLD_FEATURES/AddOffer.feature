Feature: Add Offer Page

Scenario: Navigate to accounts page
    # Given I am on offer page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Add Offer" within "#AddOffer"
    Then I should be on add offer page
    # Given I am on offer page
    When I press "Back to Accounts" within "#BackToAccounts"
    Then I should be on accounts page
    
Scenario: Add offer to real user without offer
    # Given I am on offer page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Add Offer" within "#AddOffer"
    Then I should be on add offer page
    # Given I am on offer page
    When I fill in "getuser" with "testuser1" within "#UserAdd"
    When I choose "Free Delivery" within "#UserAdd"
    When I press "Apply" within "#UserAdd"
    Then I should see "User has not won this offer"
    
Scenario: Add offer to user that doesn't exist
    # Given I am on offer page
    Given I am on login page
    When I fill in "twitter_handle" with "account_admin" within "#login"
    When I fill in "password" with "Accountadmin1" within "#login"
    When I press "submit" within "#login"
    Then I should be on accounts page
    When I press "Add Offer" within "#AddOffer"
    Then I should be on add offer page
    # Given I am on offer page
    When I fill in "getuser" with "notarealuser" within "#UserAdd"
    When I choose "Free Pie" within "#UserAdd"
    When I press "Apply" within "#UserAdd"
    Then I should see "User does not exist"