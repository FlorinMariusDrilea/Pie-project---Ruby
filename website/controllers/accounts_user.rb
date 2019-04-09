require 'erb'
require 'sinatra'
require 'sqlite3'
set :bind, '0.0.0.0'

include ERB::Util

before do
    @database = SQLite3::Database.new './accounts.sqlite'
end

get '/accounts/*' do
    user = params[:splat][0]
    
    erb :page_change_user_data
end