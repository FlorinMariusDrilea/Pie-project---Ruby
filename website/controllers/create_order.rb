require 'erb'
require 'sinatra'
require 'sqlite3'

include ERB::Util

before do
    #Initialises database variables
    @pie_db = SQLite3::Database.new "pies.sqlite"
    @accounts_db = SQLite3::Database.new "accounts.sqlite"
    @menu_db = SQLite3::Database.new "menu.sqlite" 
    @location = session[:location]
end


get '/create_order' do 
    #Redirects invalid users
    redirect '/login_access_restricted_order_admin' if session[:logged_in_order].nil?
   
    edit_i = params[:edit_item]
    if edit_i != nil
        redirect '/create_order/' + edit_i
    end
    
    
    @pies = @pie_db.execute 'SELECT * FROM pies WHERE location = ? ORDER BY orderid DESC',[@location]
    @orders = @pie_db.execute 'SELECT * FROM orders WHERE location = ? ORDER BY orderid DESC',[@location]
    if @location == "sheffield" then
        @menu = @menu_db.execute 'SELECT * FROM shef_menu'
    end
    if @location == "leeds" then
        @menu = @menu_db.execute 'SELECT * FROM leeds_menu'
    end    
    erb :page_create_order
end

#Code when the add pie button is pressed to add a pie within an order to the pies table if the inputs are valid
post '/create_order' do
    redirect '/login_access_restricted_order_admin' if session[:logged_in_order].nil?
    #Gets form data
    pie_type = params[:pie_type]
    quantity = params[:quantity]
    user = params[:user]
    #Initialises validation variables
    @user_valid = true
    @pie_valid = true
    @quant_valid = true
    @order_valid = true
    @stock_valid = true
    #Checks other databases to confirm inputs are correct
    if @location == "sheffield" then
        pie_exists = @menu_db.get_first_value 'SELECT COUNT(*) FROM shef_menu WHERE id = ?',[pie_type]
    end
    if @location == "leeds" then
        pie_exists = @menu_db.get_first_value 'SELECT COUNT(*) FROM leeds_menu WHERE id = ?',[pie_type]
    end 
    
    account_exists = @accounts_db.get_first_value 'SELECT COUNT(*) FROM accounts WHERE twitterhandle = ?',[user]
    #Checking input is database input valid
    if pie_type.nil? || pie_type == "" || pie_exists != 1 then 
        @pie_valid = false
    end
    if quantity.nil? || quantity == "" then 
        @quant_valid = false
    end
    if user.nil? || user == "" || account_exists != 1 then
        @user_valid = false
    end  

   #Checks size of databases
    pies_check = @pie_db.get_first_value 'SELECT COUNT(*) FROM pies ORDER BY orderid DESC'
    orders_check = @pie_db.get_first_value 'SELECT COUNT(*) FROM orders ORDER BY orderid DESC'
    
    if pies_check != 0 then
        if orders_check != 0 then
            #If this is not the first order then the current orderid is 1 higher than the highest id in the orders table
            new_id = @pie_db.get_first_value 'SELECT MAX(orderid)+1 FROM orders'
        else
            #This is the case where it is the first order but not the first pie so it gets the last pie id
            new_id = @pie_db.get_first_value 'SELECT MAX(orderid) FROM pies'
        end
    else
        #Case for first item in the pie table
        new_id = 100
    end 
    #Pie_values gets the pie and user of all the pies from the current order in the pies table
    pie_values = @pie_db.execute 'SELECT pieid, twitterhandle FROM pies WHERE orderid = (?)',[new_id]
    pie_values.each do |item|
        #Checks the pies is unique to the order
        if pie_type.to_i == item[0].to_i then
             @pie_valid = false
        end
        #Checks the user is consistent in the order
        if user.to_s != item[1].to_s then
            @user_valid = false
        end
    end
   
    #If inputs are valid add the pie to the table
    if @pie_valid != false && @user_valid != false && @quant_valid != false then
        if @location == "sheffield" then
            item_stock = @menu_db.get_first_value 'SELECT stock FROM shef_menu WHERE id = ?',[pie_type]
        end
        if @location == "leeds" then
            item_stock = @menu_db.get_first_value 'SELECT stock FROM leeds_menu WHERE id = ?',[pie_type]
        end 
        if quantity.to_i <= item_stock then
            if @location == "sheffield" then
                @menu_db.execute 'UPDATE shef_menu SET stock = ? WHERE id = ?',[item_stock.to_i-quantity.to_i,pie_type.to_i]
            end
            if @location == "leeds" then
                @menu_db.execute 'UPDATE leeds_menu SET stock = ? WHERE id = ?',[item_stock.to_i-quantity.to_i,pie_type.to_i]
            end 
            @pie_db.execute 'INSERT INTO pies VALUES (?,?,?,?,?,?)',[user, pie_type, quantity, new_id, 'Active', @location]
            params[:pie_type] = ""
            params[:quantity] = ""
        else
            @stock_valid = false
        end       
    end    
        
    @pies = @pie_db.execute 'SELECT * FROM pies WHERE location = ? ORDER BY orderid DESC',[@location]
    @orders = @pie_db.execute 'SELECT * FROM orders WHERE location = ? ORDER BY orderid DESC',[@location]
    if @location == "sheffield" then
        @menu = @menu_db.execute 'SELECT * FROM shef_menu'
    end
    if @location == "leeds" then
        @menu = @menu_db.execute 'SELECT * FROM leeds_menu'
    end    
    erb :page_create_order    
end

post '/order_complete' do
    redirect '/login_access_restricted_order_admin' if session[:logged_in_order].nil?
    @user_valid = true
    @pie_valid = true
    @quant_valid = true
    @order_valid = true
    #Variables used to calculate current position in table an other data related to pies within the order 
    current_id = @pie_db.get_first_value 'SELECT MAX(orderid) FROM pies'
    twitterhandle = @pie_db.get_first_value 'SELECT twitterhandle FROM pies ORDER BY orderid DESC'
    last_id = @pie_db.get_first_value 'SELECT MAX(orderid) FROM orders'
    #Pie_values stores all the pies and their quantities within an order
    pie_values = @pie_db.execute 'SELECT pieid,quantity FROM pies WHERE orderid = (?)', [current_id]
    #Checks size of databases
    pies_check = @pie_db.get_first_value 'SELECT COUNT(*) FROM pies ORDER BY orderid DESC'
    orders_check = @pie_db.get_first_value 'SELECT COUNT(*) FROM orders ORDER BY orderid DESC' 
    #Only runs if databases are not empty and atleast 1 pie has been added to the order since the last order was confirmed
    if pies_check != 0 && (last_id != current_id || orders_check == 0) then
        price = 0
        #Adds up the prices of all of the pies
        pie_values.each do |item|
            if @location == "sheffield" then
                item_price = (@menu_db.get_first_value 'SELECT price FROM shef_menu WHERE id = ?',[item[0]]) * item[1].to_i
                price = price + item_price
            end
            if @location == "leeds" then
                item_price = (@menu_db.get_first_value 'SELECT price FROM leeds_menu WHERE id = ?',[item[0]]) * item[1].to_i
                price = price + item_price
            end      
        end
        #Adds the order to the database
        @pie_db.execute('INSERT INTO orders VALUES (?,?,?,?)',[twitterhandle, current_id, price, @location]) 
        @order_valid = true
        #Marks pies within order as completed
        @pie_db.execute 'UPDATE pies SET completion = ? WHERE orderid = ?',['Processed', current_id]
    else
        @order_valid = false
    end
    redirect '/create_order'   
end
        
get '/create_order/*' do
    pie_val = params[:splat][0].to_i
    if params[:pie_edit] == nil
        current_id = @pie_db.get_first_value 'SELECT MAX(orderid) FROM pies'
        @pies = @pie_db.execute 'SELECT * FROM pies WHERE orderid = ? AND pieid = ?',[current_id, pie_val.to_s]  
        @pies.each do |record|
            params[:edit_pie_type] = record[1]
            params[:edit_pie_quantity] = record[2]
        end
        if @location == "sheffield" then
            @menu = @menu_db.execute 'SELECT * FROM shef_menu'
        end
        if @location == "leeds" then
            @menu = @menu_db.execute 'SELECT * FROM leeds_menu'
        end 
        erb :page_edit_order
    else
       new_pie = params[:edit_pie_type].to_i
       new_quant = params[:edit_pie_quantity].to_i
       redirect 'edit_order/' + pie_val.to_s + '/' +new_pie.to_s + '/' + new_quant.to_s        
    end
end
      
get '/edit_order/*/*/*' do
    old_pie = params[:splat][0].to_i
    new_pie = params[:splat][1].to_i
    new_quant = params[:splat][2].to_i
    current_id = @pie_db.get_first_value 'SELECT MAX(orderid) FROM pies'
    old_quant = @pie_db.get_first_value 'SELECT quantity FROM pies WHERE orderid = ? AND pieid = ?',[current_id.to_s, old_pie.to_s]
    old_quant = old_quant.to_i
    twitterhandle = @pie_db.get_first_value 'SELECT twitterhandle FROM pies ORDER BY orderid DESC'
    if @location == "sheffield" then
        pie_exists = @menu_db.get_first_value 'SELECT COUNT(*) FROM shef_menu WHERE id = ?',[new_pie]
        if pie_exists == 1 then
            item_stock_old = @menu_db.get_first_value 'SELECT stock FROM shef_menu WHERE id = ?',[old_pie]
            @menu_db.execute 'UPDATE shef_menu SET stock = ? WHERE id = ?',[item_stock_old+old_quant.to_i,old_pie]
            item_stock_new = @menu_db.get_first_value 'SELECT stock FROM shef_menu WHERE id = ?',[new_pie]
            if new_quant <= item_stock_new then
                @menu_db.execute 'UPDATE shef_menu SET stock = ? WHERE id = ?',[item_stock_new.to_i-new_quant,new_pie]
                @pie_db.execute 'DELETE FROM pies WHERE orderid = ? AND pieid = ?',[current_id.to_s, old_pie.to_s]
                @pie_db.execute 'INSERT INTO pies VALUES (?,?,?,?,?,?)',[twitterhandle, new_pie.to_i, new_quant.to_i, current_id.to_i, 'Active', @location]
                redirect '/create_order'
            else
                @menu_db.execute 'UPDATE shef_menu SET stock = ? WHERE id = ?',[item_stock_old,old_pie]
                redirect 'create_order/' + old_pie.to_s
            end
        else
            redirect 'create_order/' + old_pie.to_s
        end
    end
    if @location == "leeds" then
        pie_exists = @menu_db.get_first_value 'SELECT COUNT(*) FROM leeds_menu WHERE id = ?',[new_pie]
        if pie_exists == 1 then
            item_stock_old = @menu_db.get_first_value 'SELECT stock FROM leeds_menu WHERE id = ?',[old_pie]
            @menu_db.execute 'UPDATE leeds_menu SET stock = ? WHERE id = ?',[item_stock_old+old_quant.to_i,old_pie]
            item_stock_new = @menu_db.get_first_value 'SELECT stock FROM leeds_menu WHERE id = ?',[new_pie]
            if new_quant <= item_stock_new then
                @menu_db.execute 'UPDATE leeds_menu SET stock = ? WHERE id = ?',[item_stock_new.to_i-new_quant,new_pie]
                @pie_db.execute 'DELETE FROM pies WHERE orderid = ? AND pieid = ?',[current_id.to_s, old_pie.to_s]
                @pie_db.execute 'INSERT INTO pies VALUES (?,?,?,?,?,?)',[twitterhandle, new_pie.to_i, new_quant.to_i, current_id.to_i, 'Active', @location]
                redirect '/create_order'
            else
                @menu_db.execute 'UPDATE leeds_menu SET stock = ? WHERE id = ?',[item_stock_old,old_pie]
                redirect 'create_order/' + old_pie.to_s
            end
        else
            redirect 'create_order/' + old_pie.to_s
        end
    end
end