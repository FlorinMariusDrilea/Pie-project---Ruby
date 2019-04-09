Feature: Order manager


Scenario: Seperating order tweets
        Given I am on login page
        When I fill in "twitter_handle" with "order_admin" within "#login"
        When I fill in "password" with "Orderadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on order manager page
        When I press "Orders" within "#Orders"
        Then I should be on order manager order page
   
Scenario: Showing all tweets
    Given I am on login page
    When I fill in "twitter_handle" with "order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on order manager order page
    When I press "All" within "#All"
    Then I should be on order manager page

#The next two tests simply check that when you click the next button that it remains on the same page and doesnt crash. They do not check that the parameters are being passed correctly or that it functions properly

Scenario: Pressing next when displaying all tweets
Given I am on login page
    When I fill in "twitter_handle" with "order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on order manager page
    When I press "Next" within "#Next"
    Then I should be on order manager page
      
Scenario: Pressing next when displaying only order tweets
    Given I am on login page
    When I fill in "twitter_handle" with "order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on order manager order page
    When I press "Next" within "#Next"
    Then I should be on order manager order page
 
 #The next two tests simply check that when you click the tweet button that it remains on the same page and doesnt crash. They do not check that the parameters are being passed correctly or that it functions properly
 Scenario: Sending a tweet from the order mangager page
 Given I am on login page
    When I fill in "twitter_handle" with "order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on order manager page
    When I press "Tweet" within "#tweet"
    Then I should be on order manager page
 
 Scenario: Sending a tweet from the order mangager order page
    Given I am on login page
    When I fill in "twitter_handle" with "order_admin" within "#login"
    When I fill in "password" with "Orderadmin1" within "#login"
    When I press "submit" within "#login"
    Then I am on order manager order page
    When I press "Tweet" within "#tweet"
    Then I should be on order manager order page