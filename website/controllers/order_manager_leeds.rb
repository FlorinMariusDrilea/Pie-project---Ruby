before do
config = {
:consumer_key => 'IWLpj1rppWraPjtRk6lKrE0LN',
:consumer_secret => 'Nfse5RrUD0E2zYLIAj2oG1gUDtgt3kFmz5LK5VzQhNyCZ1NgZC',
:access_token => '968518671969775617-zEFGTsTWQBqxl5JSZnhBxzDy76WUOf8',
:access_token_secret => 'K5G38EtUpeoLOKWF1HKF5NriKcriJwEPHptMPpp1T0gIN'
}
@client = Twitter::REST::Client.new(config)
@pie_db = SQLite3::Database.new "pies.sqlite"     
@database = SQLite3::Database.new './accounts.sqlite'
    
end

get '/order_manager_leeds' do
    submit = params[:submit]
    nxt = params[:nxt]
    nextid = params[:nxtid] 
    user = params[:User] 
    if user != nil
        redirect '/order_manager/' + user
    end
    if nxt == "Next"
        results = @client.search('ise2018team04', max_id: nextid )
        @tweets = results.take(10) 
         @filteredtweets = []
        query = %{SELECT twitterhandle FROM accounts WHERE twitterhandle = ?} 
        query_postcode = %{SELECT postcode FROM accounts WHERE twitterhandle = ?}
        
        @tweets.each do |tweet| 
              if tweet.user.screen_name == @database.get_first_value(query,[tweet.user.screen_name]) && @database.get_first_value(query_postcode,[tweet.user.screen_name]).upcase.start_with?('LS')
                  @filteredtweets.push(tweet)
              end
        end
        @nxtid = @filteredtweets.last.id 
    else
        results = @client.search('ise2018team04')
        @tweets = results.take(10)
        @filteredtweets = []
        query = %{SELECT twitterhandle FROM accounts WHERE twitterhandle = ?} 
        query_postcode = %{SELECT postcode FROM accounts WHERE twitterhandle = ?}
        
        @tweets.each do |tweet| 
              if tweet.user.screen_name == @database.get_first_value(query,[tweet.user.screen_name]) && @database.get_first_value(query_postcode,[tweet.user.screen_name]).upcase.start_with?('LS')
                  @filteredtweets.push(tweet)
              end
        end
       # query = %{SELECT twitterhandle FROM accounts WHERE twitterhandle = ?} 
       # @tweets.delete_if { |tweet| @database.execute(query,[tweet.user.screen_name]).nil? }
        @nxtid = @filteredtweets.last.id
    end
    if submit == "Tweet" && params[:tweetcontents] != ""
       @client.update(params[:tweetcontents])
    end
    @orders = @pie_db.execute 'SELECT * FROM orders WHERE location = "leeds"'
    erb :page_order_manager
end

get '/order_manager_orders' do
    redirect '/login_access_restricted_order_admin' if session[:logged_in_order].nil?
    
    submit = params[:submit]
    nxt = params[:nxt]
    nextid = params[:nxtid]
if nxt == "Next"
        results = @client.search('"ise2018team04" + "order"', max_id: nextid)
        @tweets = results.take(10) 
     @filteredtweets = []
        query = %{SELECT twitterhandle FROM accounts WHERE twitterhandle = ?} 
        query_postcode = %{SELECT postcode FROM accounts WHERE twitterhandle = ?}
        
        @tweets.each do |tweet| 
              if tweet.user.screen_name == @database.get_first_value(query,[tweet.user.screen_name]) && @database.get_first_value(query_postcode,[tweet.user.screen_name]).upcase.start_with?('LS')
                  @filteredtweets.push(tweet)
              end
        end
        @nxtid = @filteredtweets.last.id
    else
        results = @client.search('"ise2018team04" + "order"')
        @tweets = results.take(10)
     @filteredtweets = []
        query = %{SELECT twitterhandle FROM accounts WHERE twitterhandle = ?} 
        query_postcode = %{SELECT postcode FROM accounts WHERE twitterhandle = ?}
        
        @tweets.each do |tweet| 
              if tweet.user.screen_name == @database.get_first_value(query,[tweet.user.screen_name]) && @database.get_first_value(query_postcode,[tweet.user.screen_name]).upcase.start_with?('LS')
                  @filteredtweets.push(tweet)
              end
        end
        @nxtid =@filteredtweets.last.id
    end
    if submit == "Tweet" && params[:tweetcontents] != ""
       @client.update(params[:tweetcontents])
    end
    @orders = @pie_db.execute 'SELECT * FROM orders WHERE location = "leeds"'
    erb :page_order_manager
end