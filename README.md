### Getting started
To deploy our application: 


1. Make a Codio box, selecting the “Ruby + rails" stack. (*This will ensure sqlite3 is installed correctly.*)
2. Open the Terminal, noting your Codio Box domain. (for example, `alibi-jimmy.codio.io[1111:9999]`)
3. Clone our GitHub repository by typing `git clone https://github.com/COM1001-ComputerScience-Sheffield/team-04.git`
4. Navigate to the website folder: `cd team-04/website`
5. Install rake by typing `sudo gem install rake`
6. Type `rake deploy` to launch the app on your Codio box. (*This will install all the prerequisite Gems for our application if they are not installed on your box already.*)
7. Note the port that the Sinatra application is running on and combine it with your Codio Box domain:

For instance, with the above examples, the app is running on `alibi-jimmy.codio.io:4567/`. Navigate to this address in your web browser to load the application.

NOTE: Many of the features on the application require you to be logged in with specific user details. The table below shows the various user accounts, their details, and their assosciated pages:

| Account Name     | Username       | Password        | Relevant pages 
| ---------------- | -------------- | --------------- | ----------------------------------------------------------------------------------
| Menu Admin       | shef_menu_admin, leeds_menu_admin| Menuadmin1      | /, /shef_menu, /leeds_menu
| Account Admin    | shef_account_admin, leeds_account_admin  | Accountadmin1   | /accounts, /add_offer, /edit_user_account, /delete_account
| Order Admin      | shef_order_admin, leeds_order_admin    | Orderadmin1     | /order_manager, /order_manager_orders, /create_order
| Marketing Admin  | shef_marketing_admin, leeds_order_admin| Marketingadmin1 | /marketing
| Customer Account | shef_testuser, leeds_testuser      | Testuser1       | /edit_my_account

*(Accounts beginning with `shef_` have permission to access their specific pages in the Sheffield store. Accounts beginning with `leeds_` are for accessing their pages in the Leeds store.)*