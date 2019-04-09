require 'erb'
require 'sinatra'
require 'sqlite3'

include ERB::Util

before do 

    @shef_results = @menu.execute 'SELECT * FROM shef_menu'  
    @leeds_results = @menu.execute 'SELECT * FROM leeds_menu' 
end


get '/menu' do
    redirect '/login_access_restricted_menu_admin' if session[:logged_in_menu].nil?
    
    if session[:location] == "sheffield"
        redirect '/shef_menu'
    else if session[:location] == "leeds"
        redirect '/leeds_menu'
    end
end
end
