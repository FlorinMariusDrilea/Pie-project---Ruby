Feature: Leeds order page

When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
Scenario: Logging in 
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page

 Scenario: Showing all tweets
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "All" within "#All"
    Then I am on the leeds order manager page
    
 Scenario: Pressing next when displaying all tweets
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Next" within "#Next"
    Then I am on the leeds order manager page
    
 Scenario: Pressing most recent when displaying all tweet
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page  
    When I press "Most Recent" within "#most_recent_tweet"
    Then I am on the leeds order manager page
    
 Scenario: Seperating order tweets
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Orders" within "#Orders"
    Then I should be on the order manager order page
    
Scenario: Pressing next when displaying only order tweets
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Orders" within "#Orders"
    Then I should be on the order manager order page
    When I press "Next" within "#Next"
   Then I should be on the order manager order page
   
  Scenario: Pressing most recent when displaying order tweets
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page 
    When I press "Orders" within "#Orders"
    Then I should be on the order manager order page
    When I press "Most Recent" within "#most_recent_tweet"
    Then I am on the order manager order page 
 
 Scenario: logout from the order page
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Log out" within "#log_out_button"
    Then I am on the logout page
    
 Scenario: create a new order
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Create a new order" within "#create_order"
    Then I am on the create order page
    
 Scenario: go to users page
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page  
    
 Scenario: Sending a tweet from the order mangager page
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Tweet" within "#tweet"
    Then I am on the leeds order manager page
   
 Scenario: Sending a tweet from the order mangager order page
    Given I am on the login page
    When I fill in "twitter_handle" with "leeds_order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on the leeds order manager page
    When I press "Orders" within "#Orders"
    Then I should be on the order manager order page
    When I press "Tweet" within "#tweet"
    Then I should be on the order manager order page
    
    