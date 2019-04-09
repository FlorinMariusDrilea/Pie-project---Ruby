require 'erb'
require 'sinatra'
require 'sqlite3'
require_relative 'access_restricted'
require 'digest'
set :bind, '0.0.0.0'
include ERB::Util

enable :sessions
set :session_secret, 'super secret'

before do
    @db = SQLite3::Database.new './accounts.sqlite'
    @dba = SQLite3::Database.new './adminAccounts.sqlite'
end

get '/login' do
    @submitted = false
    erb :page_login
end

post '/login_form_handler' do
    @submitted = true
    #Sanitizing inputs
    @twitter_handle = params[:twitter_handle].strip
    @password = params[:password].strip

    #Encrypting information
    @password = Digest::SHA256.hexdigest @password
    
    #Verifying whether the username and password are in the ADMINS table
    username = @dba.get_first_value(
             'SELECT username FROM admins
              WHERE username = ? AND password = ? ',
             [@twitter_handle,@password])
    if(!username.nil?)
        job = @dba.get_first_value(
                'SELECT job FROM admins 
                WHERE username = ? AND password = ?',
                [@twitter_handle,@password])
        location = @dba.get_first_value(
                'SELECT location FROM admins 
                WHERE username = ? AND password = ?',
                [@twitter_handle,@password])
        case location
        when 'sheffield'
            session[:location] = 'sheffield'
        when 'leeds'
            session[:location] = 'leeds'
        end
        case job
        when 'menu'
            session[:logged_in_menu] = true
            redirect '/menu'
        when 'account'
            session[:logged_in_account] = true
            redirect '/accounts'
        when 'order'
            session[:logged_in_order] = true
            redirect '/order_manager'
        when 'marketing'
            session[:logged_in_marketing] = true
            redirect '/marketing'
        end
    else
       
        #Verifying whether username and password are in the CUSTOMERS table
        twitter_handle = @db.get_first_value(
                'SELECT twitterhandle FROM accounts 
                 WHERE twitterhandle = ? AND password = ? ',
               [@twitter_handle,@password])
        if(!twitter_handle.nil?)
            session[:logged_in_customer] = twitter_handle
            redirect '/edit_my_account'
        else
            @all_ok = false
        end
        
    end
        erb :page_login
     
end
get '/logout' do
    @just_logged_out = true
    session.clear
    erb :page_login
end


