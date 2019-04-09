Feature: Accounts Page

    #---------------------------------
    # Code for the login test
    Scenario: Log in to accounts
        Given I am on login page
        When I fill in "twitter_handle" with "account_admin" within "#login"
        When I fill in "password" with "Accountadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on accounts page
    #---------------------------------
    
    
# Tests for the main accounts page
    Scenario: Searching for a user
        #Given I am on accounts page
        Given I am on login page
        When I fill in "twitter_handle" with "account_admin" within "#login"
        When I fill in "password" with "Accountadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on accounts page
        When I fill in "search" with "testuser2" within "#SearchUsers"
        When I press "Search" within "#SearchUsers"
        Then I should see "testuser2" within "table"

    Scenario: Navigating to add offer page
        #Given I am on accounts page
        Given I am on login page
        When I fill in "twitter_handle" with "account_admin" within "#login"
        When I fill in "password" with "Accountadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on accounts page
        When I press "Add Offer" within "#AddOffer"
        Then I should be on add offer page

    Scenario: Navigating to edit account page
        #Given I am on accounts page
        Given I am on login page
        When I fill in "twitter_handle" with "account_admin" within "#login"
        When I fill in "password" with "Accountadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on accounts page
        When I press "Edit Account" within "#EditAccount"
        Then I should be on edit account page

    Scenario: Navigating to delete account page
        #Given I am on accounts page
        Given I am on login page
        When I fill in "twitter_handle" with "account_admin" within "#login"
        When I fill in "password" with "Accountadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on accounts page
        When I press "Delete Account" within "#DeleteAccount"
        Then I should be on delete account page