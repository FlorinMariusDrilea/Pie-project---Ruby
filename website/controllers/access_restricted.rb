#Instructions for making a page admin_only accessible:
#For the menu admin:
#Copy paste this at the first line of every page you want to be admin only accessible: 
#redirect '/login_access_restricted_menu_admin' if session[:logged_in_menu].nil?
#
#For the account admin:
#Copy paste this at the first line of every page you want to be admin only accessible: 
#redirect '/login_access_restricted_account_admin' if session[:logged_in_account].nil?
#
#For the order admin:
#Copy paste this at the first line of every page you want to be admin only accessible: 
#redirect '/login_access_restricted_order_admin' if session[:logged_in_order].nil?
#
#For the marketing admin:
#Copy paste this at the first line of every page you want to be admin only accessible: 
#redirect '/login_access_restricted_marketing_admin' if session[:logged_in_marketing].nil?
#
#ADMIN ACCOUNTS:
#username|password
#menu_admin|Menuadmin1
#account_admin|Accountadmin1
#order_admin|Orderadmin1
#marketing_admin|Marketingadmin1

get '/login_access_restricted_account_edit' do
   @access_restricted_account_edit = true;
   erb :page_access_restricted
end
get '/login_access_restricted_menu_admin' do
    @access_restricted_menu_admin = true;
    erb :page_access_restricted
end
get '/login_access_restricted_account_admin' do
    @access_restricted_account_admin = true;
    erb :page_access_restricted
end
get '/login_access_restricted_order_admin' do
    @access_restricted_order_admin = true;
    erb :page_access_restricted
end
get '/login_access_restricted_marketing_admin' do
    @access_restricted_marketing_admin = true;
    erb :page_access_restricted        
end

