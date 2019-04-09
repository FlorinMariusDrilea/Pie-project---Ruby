Feature: Marketing
Scenario: I am able to log in and see the marketing page
    Given I am on login page
    When I fill in "twitter_handle" with "marketing_admin" within "#login"
    When I fill in "password" with "Marketingadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on marketing page

Scenario: Pressing next when displaying tweets with the hashtag competitionPie04
    Given I am on login page
    When I fill in "twitter_handle" with "marketing_admin" within "#login"
    When I fill in "password" with "Marketingadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on marketing page
    When I press "Next" within "#Next"
    Then I should be on marketing page
     
    
