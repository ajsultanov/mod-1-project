require_relative '../config/environment'
# require_relative '../lib/api_communicator.rb'
# require_relative '../lib/command_line_interface.rb'

welcome
user = User.find_or_create_by(name: user_name_prompt)

restaurant = main_menu(user)

# rest_name = restaurant_prompt
# restaurant = Restaurant.find_by(name: rest_name)
# if restaurant == nil
#   restaurant = populate_db_from_json(rest_name)
# end
# restaurant.profile

restaurant_menu(user, restaurant)
