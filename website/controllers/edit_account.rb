require 'erb'
require 'sinatra'
require 'sqlite3'
require_relative 'access_restricted'
set :bind, '0.0.0.0'
include ERB::Util

enable :sessions
set :session_secret, 'super secret'

before do
    @db = SQLite3::Database.new './accounts.sqlite'          
end

get '/edit_my_account' do
    redirect '/?error="customer_access_denied"' if session[:logged_in_customer].nil?
    @submitted = false
    
    #Getting user's values from the database in order to display them on the page
    @db.results_as_hash = true
    account_info = @db.execute %{
                       SELECT *
                       FROM accounts WHERE twitterhandle = '#{session[:logged_in_customer]}'}
    @twitter_handle = account_info[0]['twitterhandle']
    @password = account_info[0]['password']
    @email_address= account_info[0]['email']
    @address = account_info[0]['address']
    @first_name = account_info[0]['firstname']
    @last_name = account_info[0]['lastname']
    @phone_number = account_info[0]['phonenumber']
    @postcode = account_info[0]['postcode']
    @address_line1 = @address.split(' ')[0]
    @address_line2 = @address.split(' ')[1]
    
    @anyvouchers = %{SELECT COUNT(*) FROM account_vouchers WHERE twitterhandle = '#{session[:logged_in_customer]}'}
    vouchers = %{SELECT * FROM account_vouchers WHERE twitterhandle = '#{session[:logged_in_customer]}'}
    @vouchers = @database.execute vouchers
    
    erb :page_edit_my_account
end

post '/edit_account_form_handler' do
    redirect '/?error="customer_access_denied"' if session[:logged_in_customer].nil?
    
    @submitted = true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    #Sanitizing inputs
    @twitter_handle = params[:twitter_handle].strip
    @password = params[:password].strip
    @confirm_password = params[:confirm_password].strip
    @email_address = params[:email_address].strip
    @first_name = params[:first_name].strip
    @last_name = params[:last_name].strip
    @phone_number = params[:phone_number].strip
    @address_line1 = params[:address_line1].strip
    @address_line2 = params[:address_line2].strip
    @postcode = params[:postcode].strip  
    
    #Creating the address out of the 2 address lines
    @address = @address_line1 + " " + @address_line2
    
    #Validating inputs.    
    @twitter_handle_ok = !@twitter_handle.nil? && @twitter_handle != ""
    @twitter_handle_format_ok = !@twitter_handle.include?("admin") && !@twitter_handle.include?(" ")
    @password_ok = !@password.nil? && @password != ""
    @email_address_ok = !@email_address.nil? && @email_address != ""
    @email_address_format_ok = @email_address =~ VALID_EMAIL_REGEX
    @first_name_ok = !@first_name.nil? && @first_name !=""
    @last_name_ok = !@last_name.nil? && @last_name !=""
    @phone_number_ok = !@phone_number.nil? && @phone_number != ""
    @address_ok = !@address.nil? && @address != ""
    @postcode_ok = !@postcode.nil? && @postcode != ""
    
    #Checking password constraints
    @password_match = @password == @confirm_password
    @password_count_ok = @password.length >= 6
    @password_all_ok = @password_ok && @password_match && @password_count_ok
    
    #Checking phone number constraints
    @phone_number_is_number = @phone_number =~ /^[0-9]*$/
    @phone_number_count_ok = @phone_number.length >= 11
    @phone_number_all_ok = @phone_number_ok && @phone_number_is_number && @phone_number_count_ok
      
     #Checking whether the user is in the local area or not    
       #Checking postcode:
         #Sheffield:
    if(@postcode.upcase.start_with?('S'))
        @postcode_local_ok = true;
        #Leeds:
    elsif(@postcode.upcase.start_with?('LS'))
        @postcode_local_ok = true;
    end
    
    #Veryfing whether the twitter handle is unique
    count = @db.get_first_value(
      'SELECT COUNT(*) FROM accounts WHERE twitterhandle = ?',
      [@twitter_handle])
    @unique_twitter_handle = true if count == 0
    #Encrypting information
    @password = Digest::SHA256.digest @password
    
    #Comparing user's inputs to the user's values in the database to figure out whether they made any changes
    #This is useful information for writing the success messages in the template
    @db.results_as_hash = true
    account_info = @db.execute %{
                       SELECT *
                       FROM accounts WHERE twitterhandle = '#{session[:logged_in_customer]}'}
     @twitter_handle_changed = true if (@twitter_handle != account_info[0]['twitterhandle'])
     @password_changed       = true if (@password != account_info[0]['password'])
     @email_address_changed  = true if (@email_address != account_info[0]['email'])
     @address_changed        = true if (@address != account_info[0]['address'])
     @first_name_changed     = true if (@first_name != account_info[0]['firstname'])
     @last_name_changed      = true if (@last_name != account_info[0]['lastname'])
     @phone_number_changed   = true if (@phone_number != account_info[0]['phonenumber'])
     @postcode_changed       = true if (@postcode != account_info[0]['postcode'])
    
    #Updating user's information
    if (@twitter_handle_ok && @unique_twitter_handle && @twitter_handle_format_ok)
        @db.execute(%{UPDATE accounts SET twitterhandle = ?
                    WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                    [@twitter_handle])
        #Updating the session to avoid a bug concerning the database
        session[:logged_in_customer] = @twitter_handle
    end
    if (@password_all_ok)
        @db.execute(%{UPDATE accounts SET password = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                     [@password])
    end
    if (@email_address_ok && @email_address_format_ok)
        @db.execute(%{UPDATE accounts SET email = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                      [@email_address])
    end
    if (@address_ok)
        @db.execute(%{UPDATE accounts SET address = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                      [@address])
    end
    if (@first_name_ok)
        @db.execute(%{UPDATE accounts SET firstname = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                      [@first_name])
    end
    if (@last_name_ok)
        @db.execute(%{UPDATE accounts SET lastname = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                      [@last_name])
    end
    if (@phone_number_all_ok)
        @db.execute(%{UPDATE accounts SET phonenumber = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                      [@phone_number])
    end
    if (@postcode_ok && @postcode_local_ok)
        @db.execute(%{UPDATE accounts SET postcode = ?
                      WHERE twitterhandle = '#{session[:logged_in_customer]}'},
                     [@postcode])
    end
       
    #Getting user's values from the database in order to display them on the page
    @db.results_as_hash = true
    account_info = @db.execute %{
                       SELECT *
                       FROM accounts WHERE twitterhandle = '#{session[:logged_in_customer]}'}
    @twitter_handle = account_info[0]['twitterhandle']
    @password = account_info[0]['password']
    @email_address= account_info[0]['email']
    @address = account_info[0]['address']
    @first_name = account_info[0]['firstname']
    @last_name = account_info[0]['lastname']
    @phone_number = account_info[0]['phonenumber']
    @postcode = account_info[0]['postcode']
    @address_line1 = @address.split(' ')[0]
    @address_line2 = @address.split(' ')[1]
   
    erb :page_edit_my_account   
end