
before do
config = {
:consumer_key => 'IWLpj1rppWraPjtRk6lKrE0LN',
:consumer_secret => 'Nfse5RrUD0E2zYLIAj2oG1gUDtgt3kFmz5LK5VzQhNyCZ1NgZC',
:access_token => '968518671969775617-zEFGTsTWQBqxl5JSZnhBxzDy76WUOf8',
:access_token_secret => 'K5G38EtUpeoLOKWF1HKF5NriKcriJwEPHptMPpp1T0gIN'
}
@client = Twitter::REST::Client.new(config)
@pie_db = SQLite3::Database.new "pies.sqlite"     
@db = SQLite3::Database.new "accounts.sqlite" 
     
end


get '/order_manager/*' do
    @user = params[:splat][0]
    submit = params[:submit]
    nxt = params[:nxt]
    nextid = params[:nxtid] 
    @offername = params[:offer_name]
    @Orderid = params[:orderid]
    @applyoffer = params[:apply_offer]
    vouchers = %{SELECT * FROM account_vouchers WHERE twitterhandle LIKE '%' || ? || '%'}
    @vouchers = @db.execute vouchers, @user
    
    if nxt == "Next"
        results = @client.search(@user, max_id: nextid )
        @tweets = results.take(10) 
        @nxtid = @tweets.last.id 
    else
        results = @client.search(@user)
        @tweets = results.take(10)
        @nxtid = @tweets.last.id
    end
    if submit == "Tweet" && params[:tweetcontents] != ""
       @client.update(params[:tweetcontents])
    end
    @orders = @pie_db.execute 'SELECT * FROM orders WHERE location = ?',[session[:location]]
    
 if @applyoffer != nil 
    
    @pricechange = @db.get_first_value 'SELECT effect FROM vouchers WHERE voucher_name = ?',[@offername]
    @pricechange = @pricechange.to_f
    @oldorderprice = @pie_db.get_first_value 'SELECT price FROM orders WHERE orderid = ?',[@Orderid.to_s] 
    @oldorderprice = @oldorderprice.to_f
    @newprice = (@pricechange * @oldorderprice)
    @pie_db.execute 'DELETE FROM orders WHERE orderid = ?',[@Orderid]
    @pie_db.execute 'INSERT INTO orders VALUES(?,?,?,?)',[@user,@Orderid,@newprice,session[:location]]
    @pie_db.execute 'DELETE FROM orders WHERE orderid = ?',[@Orderid]
    @pie_db.execute 'INSERT INTO orders VALUES(?,?,?,?)',[@user,@Orderid,@newprice,session[:location]]
    @orders = @pie_db.execute 'SELECT * FROM orders WHERE location = ?',[session[:location]]
    deletevouchers = %{DELETE FROM account_vouchers WHERE twitterhandle LIKE '%' || ? || '%' AND offer = ?}    
    @db.execute deletevouchers,@user,@offername
     
    redirect '/order_manager/' + @user
 end
    
    erb :page_order_manager_personal
end