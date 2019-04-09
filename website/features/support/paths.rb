module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
        
    when /the home page/
        '/'
    when /the login page/
        '/login'    
    when /the sheffield menu page/
        '/shef_menu'
    when /the leeds menu page/
        '/leeds_menu'
    when /the login form handler page/
        '/login_form_handler'
    when /the sheffield order manager page/
        '/order_manager_shef'
    when /the leeds order manager page/
        '/order_manager_leeds'
    when /the order manager order page/
        '/order_manager_orders'
    when /the logout page/
        '/logout'
    when /the create order page/
        '/create_order'
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"

    end
  end
end

World(NavigationHelpers)
