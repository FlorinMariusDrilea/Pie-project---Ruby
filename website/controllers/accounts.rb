require 'erb'
require 'sinatra'
require 'sqlite3'
set :bind, '0.0.0.0'

include ERB::Util

before do
    @database = SQLite3::Database.new './accounts.sqlite'
    @message = ""
end

get '/accounts' do
    redirect '/login_access_restricted_account_admin' if session[:logged_in_account].nil?
    
    user = params[:user]
    search = params[:search]
    
    if !search.nil?
        account = %{SELECT * FROM accounts WHERE twitterhandle LIKE '%' || ? || '%'}
        @accounts = @database.execute account, search
    else
        account = %{SELECT * FROM accounts}
        @accounts = @database.execute account
    end
    
    if user != nil
        redirect '/accounts/' + user
    end
    
    @anyupdates = %{SELECT COUNT(*) FROM voucher_updates}
    
    update = %{SELECT * FROM voucher_updates}
    @updates = @database.execute update
    
    erb :page_accounts
end


get '/add_offer' do
    redirect '/login_access_restricted_account_admin' if session[:logged_in_account].nil?
    @submitted = false
    
    erb :page_add_offer
end

post '/add_offer' do
    @submitted = true
    
    @user = params[:getuser].strip
    @offer = params[:offertype].strip
    
    realuser = @database.get_first_value('SELECT COUNT(twitterhandle) FROM accounts WHERE twitterhandle = ?',[@user] )
    @user_ok = (realuser == 1)
    
    realoffer = @database.get_first_value('SELECT COUNT(*) FROM voucher_updates WHERE twitterhandle = ? AND newoffer = ?',[@user,@offer])
    @offer_ok = (realoffer == 1)
    
    count = @database.get_first_value('SELECT COUNT(*) FROM account_vouchers WHERE twitterhandle = ? AND offer = ?',[@user,@offer])
    @unique = (count == 0)
    
    if @user_ok && @offer_ok && @unique
        @database.execute('INSERT INTO account_vouchers VALUES (?,?)',[@user,@offer])
        @database.execute('DELETE FROM voucher_updates WHERE twitterhandle = ? AND newoffer = ?',[@user,@offer])
        @message = "Successfully updated offer"
    elsif !@user_ok
        @message = "User does not exist"
    elsif !@offer_ok
        @message = "User has not won this offer"
    elsif !@unique
        @database.execute('DELETE FROM voucher_updates WHERE twitterhandle = ? AND newoffer = ?',[@user,@offer])
        @message = "User already has this offer"
    end
    
    erb :page_add_offer
end

get '/edit_user_account' do
    redirect '/login_access_restricted_account_admin' if session[:logged_in_account].nil?
    @submitted = false
    
    erb :page_edit_user_account
end

post '/edit_user_account' do
    @submitted = true
    
    @user = params[:getuser].strip
    @firstname = params[:firstname].strip
    @lastname = params[:lastname].strip
    @address = params[:address].strip
    @postcode = params[:postcode].strip
    @phone = params[:phone].strip
    @email = params[:email].strip
    
    realuser = @database.get_first_value('SELECT COUNT(twitterhandle) FROM accounts WHERE twitterhandle = ?',[@user])
    @user_ok = (realuser == 1)
    
    if @user_ok
        if !(@firstname == "")
            @database.execute('UPDATE accounts SET firstname = ? WHERE twitterhandle = ?',[@firstname,@user])
        end
        if !(@lastname == "")
            @database.execute('UPDATE accounts SET lastname = ? WHERE twitterhandle = ?',[@lastname,@user])
        end
        if !(@address == "")
            @database.execute('UPDATE accounts SET address = ? WHERE twitterhandle = ?',[@address,@user])
        end
        if !(@postcode == "")
            @database.execute('UPDATE accounts SET postcode = ? WHERE twitterhandle = ?',[@postcode,@user])
        end
        if !(@phone == "")
            @database.execute('UPDATE accounts SET phonenumber = ? WHERE twitterhandle = ?',[@phone,@user])
        end
        if !(@email == "")
            @database.execute('UPDATE accounts SET email = ? WHERE twitterhandle = ?',[@email,@user])
        end
        @message = "Successfully updated account data"
    else
        @message = "User does not exist"
    end
    
    erb :page_edit_user_account
end

get '/delete_account' do
    redirect '/login_access_restricted_account_admin' if session[:logged_in_account].nil?
    @submitted = false
    
    erb :page_delete_account
end

post '/delete_account' do
    @submitted = true
    
    @user = params[:getuser].strip
    
    realuser = @database.get_first_value('SELECT COUNT(twitterhandle) FROM accounts WHERE twitterhandle = ?',[@user])
    @user_ok = (realuser == 1)
    
    if @user_ok
        @database.execute('DELETE FROM accounts WHERE twitterhandle = ?',[@user])
        @message = "Successfully deleted account"
    else
        @message = "User does not exist"
    end
        
    
    erb :page_delete_account
end