Feature: Create order page

Scenario: Getting to create order page
        Given I am on login page
        When I fill in "twitter_handle" with "order_admin" within "#login"
        When I fill in "password" with "Orderadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on order manager page
        When I press "Create a new order" within "#create_order"
        Then I should be on create order page
    



Scenario: Going back to the order manager page
        Given I am on login page
        When I fill in "twitter_handle" with "order_admin" within "#login"
        When I fill in "password" with "Orderadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on order manager page
        When I press "Create a new order" within "#create_order"
        Then I should be on create order page
        When I press "Go back" within "#cancel_order"
        Then I should be on the order manager page
        
        
Scenario: Adding a pie to the system
        Given I am on login page
        When I fill in "twitter_handle" with "order_admin" within "#login"
        When I fill in "password" with "Orderadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on order manager page
        When I press "Create a new order" within "#create_order"
        Then I should be on create order page
        When I fill in "user" with "testuser1" within "#pie_inputs"
        When I fill in "pie_type" with "3" within "#pie_inputs"
        When I fill in "quantity" with "2" within "#pie_inputs"
        When I press "Enter" within "#pie_inputs"
        Then I should be on the create order page

Scenario: Finalising an order
        Given I am on login page
        When I fill in "twitter_handle" with "order_admin" within "#login"
        When I fill in "password" with "Orderadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on order manager page
        When I press "Create a new order" within "#create_order"
        Then I should be on create order page
        When I press "Complete order" within "#order_complete"
        Then I should be on the order completed page
        
        