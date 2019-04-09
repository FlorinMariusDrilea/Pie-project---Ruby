before do
config = {
:consumer_key => 'IWLpj1rppWraPjtRk6lKrE0LN',
:consumer_secret => 'Nfse5RrUD0E2zYLIAj2oG1gUDtgt3kFmz5LK5VzQhNyCZ1NgZC',
:access_token => '968518671969775617-zEFGTsTWQBqxl5JSZnhBxzDy76WUOf8',
:access_token_secret => 'K5G38EtUpeoLOKWF1HKF5NriKcriJwEPHptMPpp1T0gIN'
}
@client = Twitter::REST::Client.new(config)
@pie_db = SQLite3::Database.new "pies.sqlite"     

end


get '/order_manager' do
    redirect '/login_access_restricted_order_admin' if session[:logged_in_order].nil?
    redirect '/order_manager_shef' if session[:location] == "sheffield"
    redirect '/order_manager_leeds' if session[:location] == "leeds"
end