require 'erb'
require 'sinatra'
require 'sqlite3'

include ERB::Util

before do
    @menu = SQLite3::Database.new 'menu.sqlite'
end

get '/' do    
    @shef_results = @menu.execute 'SELECT * FROM shef_menu WHERE stock != 0'   
    @leeds_results = @menu.execute 'SELECT * FROM leeds_menu WHERE stock != 0'    
    erb :page_index
end
    