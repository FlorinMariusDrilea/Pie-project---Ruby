require 'sinatra'
require 'erb'
require 'twitter'
require 'date'
set :bind, '0.0.0.0'

include ERB::Util

before do
    config = {
    :consumer_key => 'IWLpj1rppWraPjtRk6lKrE0LN',
    :consumer_secret => 'Nfse5RrUD0E2zYLIAj2oG1gUDtgt3kFmz5LK5VzQhNyCZ1NgZC',
    :access_token => '968518671969775617-zEFGTsTWQBqxl5JSZnhBxzDy76WUOf8',
    :access_token_secret => 'K5G38EtUpeoLOKWF1HKF5NriKcriJwEPHptMPpp1T0gIN'
    }
    @client = Twitter::REST::Client.new(config)
    @database = SQLite3::Database.new './accounts.sqlite'
    @success_message = ""
    @hashtag_message = ""
    @start_date_message = ""
    @end_date_message = ""
end

get '/marketing' do
   redirect '/login_access_restricted_marketing_admin' if session[:logged_in_marketing].nil? 
    
    erb :page_competition_tweet_form
end

post '/marketing' do
    @submitted = true
    
    @hashtag = params[:hashtag].strip
    @start_date = params[:start_date].strip
    @start_year = @start_date[-4..-1].to_i
    @start_month = @start_date[3..4].to_i
    @start_day = @start_date[0..1].to_i
    @end_date = params[:end_date].strip
    @end_year = @end_date[-4..-1].to_i
    @end_month = @end_date[3..4].to_i
    @end_day = @end_date[0..1].to_i
    @tweet = params[:tweet].strip
    
    current_date = DateTime.now
    current_year = current_date.strftime("%Y").to_i
    current_month = current_date.strftime("%m").to_i
    current_day = current_date.strftime("%d").to_i
    
    count = @database.get_first_value('SELECT COUNT(*) FROM competitions WHERE hashtag = ?',[@hashtag])
    @unique_hashtag = (count == 0)
    
    @hashtag_ok = false
    if @hashtag[0] == "#"
        @hashtag_ok = true
    end
    
    @start_date_ok = false
    if current_year < @start_year
        @start_date_ok = true
    elsif current_year == @start_year
        if current_month < @start_month
            @start_date_ok = true
        elsif current_month == @start_month
            if current_day <= @start_day
                @start_date_ok = true
            end
        end
    end
    
    @end_date_ok = false
    if @end_year > @start_year
        @end_date_ok = true
    elsif @end_year == @start_year
        if @end_month > @start_month
            @end_date_ok = true
        elsif @end_month == @start_month
            if @end_day >= @start_day
                @end_date_ok = true
            end
        end
    end
    
    if @unique_hashtag && @hashtag_ok && @start_date_ok && @end_date_ok
        @message = "Competition Started!"
        @database.execute('INSERT INTO competitions VALUES (?,?,?)',[@hashtag,@start_date,@end_date])
        @client.update("New Comp: " + @start_date + " Until " + @end_date + " . To enter use hashtag: " + @hashtag + " " + @tweet)
    else
        if !@unique_hashtag
            @hashtag_message = "Hashtag is already part of a competition"
        end
        if !@hashtag_ok
            @hashtag_message = "Hashtag must begin with #"
        end
        if !@start_date_ok
            @start_date_message = "Start date must be today or later"
        end
        if !@end_date_ok
            @end_date_message = "End date must be after Start date"
        end
    end
    
    results = @client.search('"ise2018team04" + @compname')
    @tweets = results
    query = %{SELECT twitterhandle FROM accounts WHERE twitterhandle = ?} 
    
    @filteredtweets = []
    @tweets.each do |tweet| 
          if tweet.user.screen_name == @database.get_first_value(query,[tweet.user.screen_name])
              @filteredtweets.push(tweet)
          end
    end
    
    erb :page_competition_tweet_form
end



