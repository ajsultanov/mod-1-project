require_relative '../config/environment'
# require_relative '../lib/api_communicator.rb'
# require_relative '../lib/command_line_interface.rb'

welcome
user = User.find_or_create_by(name: user_name_prompt)

# restaurant =
main_menu(user)
