Feature: sheffield menu page

    Scenario: Testing the home button
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I press "Home"
        Then I should be on the home page
    
    Scenario: Adding a valid item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I fill in "name" with "Cucumber Pie"
        When I fill in "price" with "1.49"
        When I press "Submit" within "#add"
        Then I should see ""
        
    Scenario: Entering a duplicate ID when adding an item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I fill in "name" with "Cucumber Pie"
        When I fill in "price" with "1.49"
        When I fill in "id" with "1" within "#add" 
        When I press "Submit" within "#add"
        Then I should see "An item with that ID already exists. Please use a unique ID."
   	
    Scenario: Entering an invalid ID when removing an item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I press "Submit" within "#remove"
        Then I should see "Error: You must enter an ID before submitting."
        Then I should see "Error: An item with that ID doesn't exist."
        
        Scenario: Entering an valid ID when removing an item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I fill in "id" with "2" within "#remove"
        When I press "Submit" within "#remove"
        Then I should see ""
        
    Scenario: Entering an invalid ID when removing an item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I press "Submit" within "#remove"
        Then I should see "Error: You must enter an ID before submitting."
        Then I should see "Error: An item with that ID doesn't exist."
    
     Scenario: Entering an word as the ID when removing an item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I fill in "id" with "cucumber" within "#remove"
        When I press "Submit" within "#remove"
        Then I should see "The ID must be an integer. Only characters 0-9 are permitted."
        Then I should see "Error: An item with that ID doesn't exist."
        
     Scenario: Entering an word as the stock when adding an item
        Given I am on the login page
        When I fill in "twitter_handle" with "shef_menu_admin" within "#login"
        When I fill in "password" with "Menuadmin1" within "#login"
        When I press "submit" within "#login"
        Then I should be on the sheffield menu page
        When I fill in "stock" with "cucumber" within "#add"
        When I press "Submit" within "#add"
        Then I should see "Invalid stock - you must enter an integer."