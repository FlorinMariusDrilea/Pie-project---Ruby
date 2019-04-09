require 'sinatra'
require 'twitter'


require_relative 'controllers/order_manager.rb'
require_relative 'controllers/index.rb'
require_relative 'controllers/menu.rb'
require_relative 'controllers/shef_menu.rb'
require_relative 'controllers/leeds_menu.rb'
require_relative 'controllers/accounts.rb'
require_relative 'controllers/marketing.rb'
require_relative 'controllers/create_order.rb'
require_relative 'controllers/login.rb'
require_relative 'controllers/register.rb'
require_relative 'controllers/edit_account'
require_relative 'controllers/order_manager_user.rb'
require_relative 'controllers/order_manager_shef.rb'
require_relative 'controllers/order_manager_leeds.rb'
set :bind, '0.0.0.0'

include ERB::Util

