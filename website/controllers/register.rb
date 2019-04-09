require 'erb'
require 'sinatra'
require 'sqlite3'
require 'digest'
set :bind, '0.0.0.0'
include ERB::Util


before do
    @db = SQLite3::Database.new './accounts.sqlite'          
end

get '/register' do
    @submitted = false
    erb :page_register
end
post '/register_form_handler' do
    @submitted = true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    #Sanitizing inputs
    @twitter_handle = params[:twitter_handle].strip
    @password = params[:password].strip
    @email_address = params[:email_address].strip
    @first_name = params[:first_name].strip
    @last_name = params[:last_name].strip
    @phone_number = params[:phone_number].strip
    @address_line1 = params[:address_line1].strip
    @address_line2 = params[:address_line2].strip
    @postcode = params[:postcode]
    @confirm_password = params[:confirm_password]
    
    #Creating the address out of the 2 address lines
    @address = @address_line1 + " " + @address_line2
    
    #Validating inputs.
    @twitter_handle_ok = !@twitter_handle.nil? && @twitter_handle != ""
    @twitter_handle_format_ok = 
        !@twitter_handle.include?("admin") && !@twitter_handle.include?(" ")
    @password_ok = !@password.nil? && @password != ""
    @confirm_password_ok = !@confirm_password.nil? && @confirm_password != ""
    @email_address_ok = 
        !@email_address.nil? && @email_address != "" && @email_address =~ VALID_EMAIL_REGEX
    @first_name_ok = !@first_name.nil? && @first_name !=""
    @last_name_ok = !@last_name.nil? && @last_name !=""
    @phone_number_ok = !@phone_number.nil? && @phone_number != ""
    @address_line1_ok = !@address_line1.nil? && @address_line1 != ""
    @address_line2_ok = !@address_line2.nil? && @address_line2 != ""
    @postcode_ok = !@postcode.nil? && @postcode != ""
    
    #Checking password constraints
    @password_match = @password == @confirm_password
    @password_count_ok = @password.length >= 6
    
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
       
    #Veryfing whether the twitter handle is unique or not
    count = @db.get_first_value(
      'SELECT COUNT(*) FROM accounts WHERE twitterhandle = ?',
      [@twitter_handle])
    @unique_twitter_handle = true if count == 0
    
    @all_ok = 
        @twitter_handle_ok && @unique_twitter_handle && @twitter_handle_format_ok && @password_ok &&
        @confirm_password_ok && @password_match &&@password_count_ok && @email_address_ok && @address_line1_ok &&
        @first_name_ok &&@last_name_ok && @phone_number_ok &&@postcode_ok && @postcode_local_ok
    #Encrypting information
    @password = Digest::SHA256.hexdigest @password
    
    #Sending data to the database
    if @all_ok
        @db.execute(
            'INSERT INTO accounts (firstname,lastname,twitterhandle,password,email,address,phonenumber,postcode,totalorders)
             VALUES (?,?,?,?,?,?,?,?,0)',
            [@first_name,@last_name,@twitter_handle,@password,@email_address,@address,@phone_number,@postcode])
        session[:logged_in_customer] = @twitter_handle
        redirect '/edit_my_account'
    end

    erb :page_register
    
end
