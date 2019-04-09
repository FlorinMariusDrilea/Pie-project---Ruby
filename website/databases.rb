require 'sqlite3'
require 'digest'
begin
    db = SQLite3::Database.open "./accounts.sqlite"
    
    
    db.execute "CREATE TABLE IF NOT EXISTS `account_vouchers` (
    `twitterhandle`	TEXT NOT NULL,
    `offer`	TEXT NOT NULL,
    UNIQUE(`twitterhandle`,`offer`)
    )"
     db.execute "CREATE TABLE IF NOT EXISTS `vouchers` (
    `voucher_name`	TEXT NOT NULL,
    `effect`	FLOAT NOT NULL,
    UNIQUE(`voucher_name`,`effect`)
    )"
    db.execute "CREATE TABLE IF NOT EXISTS `accounts` (
    `firstname` TEXT NOT NULL,
    `lastname` TEXT NOT NULL,
    `address` TEXT NOT NULL,
    `twitterhandle` TEXT NOT NULL,
    `phonenumber` TEXT,
    `email` TEXT,
    `password` TEXT NOT NULL,
    `totalorders` INT NOT NULL,
    `postcode` TEXT NOT NULL,
    UNIQUE(twitterhandle)
    )"
    db.execute "CREATE TABLE IF NOT EXISTS `voucher_updates` (
    `twitterhandle`	TEXT NOT NULL,
    `newoffer`	TEXT NOT NULL,
    UNIQUE(`twitterhandle`,`newoffer`)
    )"
    db.execute "CREATE TABLE IF NOT EXISTS `competitions` (
    `hashtag` TEXT NOT NULL,
    `start_d` TEXT NOT NULL,
    `end_d` TEXT NOT NULL,
    UNIQUE(`hashtag`)
    )"
    db.execute "CREATE TABLE IF NOT EXISTS `winners` (
    `hashtag` TEXT NOT NULL,
    `twitterhandle` TEXT NOT NULL,
    UNIQUE(`hashtag`,`twitterhandle`)
    )"
    testuser1_encrypt = Digest::SHA256.hexdigest 'password1'
    testuser_encrypt = Digest::SHA256.hexdigest 'Testuser1'
    testuser2_encrypt = Digest::SHA256.hexdigest 'password2'
    testuser3_encrypt = Digest::SHA256.hexdigest 'password3'
    testuserleeds_encrypt = Digest::SHA256.hexdigest 'passwordleeds'
    testuser5_encrypt = Digest::SHA256.hexdigest 'password5'
    db.execute "INSERT OR IGNORE INTO accounts VALUES('TEST','USER1','1 Test Street','shef_testuser',07111111111,'testuser1@tests.co.uk','#{testuser_encrypt}',1,'S1 2GY')"
    db.execute "INSERT OR IGNORE INTO accounts VALUES('TEST','USER2','2 Test Street','testuser2',07222222222,'testuser2@tests.co.uk','#{testuser2_encrypt}',2,'S10 2NH')"
    db.execute "INSERT OR IGNORE INTO accounts VALUES('James','Beck','3 Test Street','beckinsforth',07111111113,'testuser3@tests.co.uk','#{testuser3_encrypt}',3,'S1 3GY')"
    db.execute "INSERT OR IGNORE INTO accounts VALUES('TEST','USER','4 Test Street','leeds_testuser',07111111122,'testuserleeds@tests.co.uk','#{testuser_encrypt}',4,'LS 3GY')"
    db.execute "INSERT OR IGNORE INTO accounts VALUES('James','Taylor','5 Test Street','JamesTa70636669',07111111322,'testuser5@tests.co.uk','#{testuser5_encrypt}',5,'LS 5GY')"
    
    db.execute "INSERT OR IGNORE INTO account_vouchers VALUES('beckinsforth','10% off')"
    db.execute "INSERT OR IGNORE INTO account_vouchers VALUES('testuser1','20% off')"
    db.execute "INSERT OR IGNORE INTO account_vouchers VALUES('testuser1','20% off')"
    db.execute "INSERT OR IGNORE INTO voucher_updates VALUES('testuser2','10% off')"
    
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('10% off',0.9)"
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('20% off',0.8)"
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('30% off',0.7)"
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('40% off',0.6)"
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('50% off',0.5)"
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('60% off',0.4)"
    db.execute "INSERT OR IGNORE INTO vouchers VALUES('70% off',0.3)"
    
    db = SQLite3::Database.open "./adminAccounts.sqlite"
    
    db.execute "CREATE TABLE IF NOT EXISTS `admins` (
    `username` TEXT NOT NULL,
    `password` TEXT NOT NULL,
    `job` TEXT NOT NULL,
    `location` TEXT NOT NULL,
    UNIQUE(username)
    )"
    account_encrypted = Digest::SHA256.hexdigest 'Accountadmin1'
    order_encrypted = Digest::SHA256.hexdigest 'Orderadmin1'
    marketing_encrypted = Digest::SHA256.hexdigest 'Marketingadmin1'
    menu_encrypted = Digest::SHA256.hexdigest 'Menuadmin1'
    db.execute "INSERT OR IGNORE INTO admins VALUES('shef_account_admin','#{account_encrypted}','account','sheffield')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('shef_order_admin','#{order_encrypted}','order','sheffield')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('shef_marketing_admin','#{marketing_encrypted}','marketing','sheffield')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('shef_menu_admin','#{menu_encrypted}','menu','sheffield')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('leeds_account_admin','#{account_encrypted}','account','leeds')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('leeds_order_admin','#{order_encrypted}','order','leeds')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('leeds_marketing_admin','#{marketing_encrypted}','marketing','leeds')"
    db.execute "INSERT OR IGNORE INTO admins VALUES('leeds_menu_admin','#{menu_encrypted}','menu','leeds')"
    
   db = SQLite3::Database.open "./menu.sqlite" 
    
    db.execute "CREATE TABLE IF NOT EXISTS `shef_menu` (
    `id` INTEGER PRIMARY KEY,
    `name` TEXT NOT NULL,
    `category` TEXT NOT NULL,
    `price` REAL NOT NULL,
    `description` TEXT,
    `stock` INTEGER NOT NULL
    )"
    
    db.execute "INSERT OR IGNORE INTO shef_menu VALUES(1, 'Steak Pie', 'Pie', 0.89, 'A pie containing Steak.', 50)"
    db.execute "INSERT OR IGNORE INTO shef_menu VALUES(2, 'Sheffield Melt', 'Pie', 0.99, 'A strange pie from Sheffield.', 0)"
    db.execute "INSERT OR IGNORE INTO shef_menu VALUES(3, 'Pint of Gravy', 'Drink', 0.69, 'Ay up me duck.', 50)"
    
    db.execute "CREATE TABLE IF NOT EXISTS `leeds_menu` (
    `id` INTEGER PRIMARY KEY,
    `name` TEXT NOT NULL,
    `category` TEXT NOT NULL,
    `price` REAL NOT NULL,
    `description` TEXT,
    `stock` INTEGER NOT NULL
    )"
    
    db.execute "INSERT OR IGNORE INTO leeds_menu VALUES(1, 'Steak Pie', 'Pie', 0.89, 'A pie containing Steak.', 50)"
    db.execute "INSERT OR IGNORE INTO leeds_menu VALUES(2, 'Leeds Melt', 'Pie', 0.99, 'A strange pie from Leeds.', 0)"
    db.execute "INSERT OR IGNORE INTO leeds_menu VALUES(3, 'Bovril', 'Drink', 0.69, 'Perfect for away days.', 50)"

    db = SQLite3::Database.open "./pies.sqlite" 
    
    db.execute "CREATE TABLE IF NOT EXISTS `pies` (
    `twitterhandle` TEXT NOT NULL,
    `pieid` TEXT NOT NULL,
    `quantity` TEXT NOT NULL,
    `orderid` TEXT NOT NULL,
    'completion' TEXT NOT NULL,
    'location' TEXT NOT NULL,
    UNIQUE(orderid, pieid)
    )"
    
    db.execute "CREATE TABLE IF NOT EXISTS `orders` (
    `twitterhandle` TEXT NOT NULL,
    `orderid` TEXT NOT NULL,
    `price` REAL NOT NULL,
    'location' TEXT NOT NULL,
    UNIQUE(orderid)
    )"

end
