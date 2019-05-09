def welcome
  puts "
  █     █          █ █
  █     █   █ █ █    █     █ █ █    █ █ █   █ █   █ █   █ █ █
  █     █  █     █   █    █        █     █  █  █ █  █  █     █
  █  █  █  █ █ █ █   █    █        █     █  █   █   █  █ █ █ █
  █ █ █ █  █         █    █        █     █  █   █   █  █
   █   █    █ █ █    █ █   █ █ █    █ █ █   █   █   █   █ █ █

                                    /\\   /\\
    █                              / /\\_/\\ \\
    █      █ █ █                   \\/ _ _ \\/       __________
  █ █ █   █     █                  |  o o  |      (,______ __)
    █     █     █                  |#     #|       \\\\  ( ) #|
    █     █     █                 / \\.   ./ \\       \\\\#  # ,|
     █ █   █ █ █                 /  >(. .)<  \\       \\\\#  (_|
                                 |    \\ /     \\       \\\\,#  |
    █     █                      |     0      |        \\\\ _#|
    █     █        █ █ █         / \\  ,     \\ \\        ,\\\\ )|
  █ █ █   █ █ █   █     █       |   \\ \\      \\ \\         \\\\ |
    █     █    █  █ █ █ █       |    \\mb      dm          \\\\|
    █     █    █  █            /                \\          ;
     █ █  █    █   █ █ █       \\     \\     /    /\\___________
                                \\__nnn\\___|nnn_/\\/_|_|_|_|_|,>

  █ █ █         █ █      █     █            █ █ █ █     █ █
  █     █     █     █    █     █                  █   █     █
  █      █   █       █   █ █ █ █                  █  █       █
  █      █   █       █   █     █    █ █ █         █  █       █
  █     █     █     █    █     █            █     █   █     █
  █ █ █   █     █ █   █  █     █  █           █ █       █ █
  "
end

def get_input
  input = gets.chomp
end

def user_name_prompt
  puts "Please enter your name to begin:"
  print "> "

  user_name = get_input
  if user_name == ""
    user_name_prompt
  end
  puts ""
  puts "Hello, #{user_name}!"
  user_name
end


def main_menu(user)
  puts ""
  puts "Welcome to the D.O.H.-Jo"
  puts "************************"
  puts "      MAIN MENU"
  puts "************************"
  puts ""
  puts "Options:"
  puts ""
  puts "1. Search the Restaurant Database!"
  puts "2. View My Favorites List"
  puts "3. Mystery Option ?????"
  puts "4. Exit the Program"
  print "> "

  option = get_input
  case option
  when "1"
    res = restaurant_prompt
    restaurant = Restaurant.find_by(name: res)
    if restaurant == nil
      restaurant = populate_db_from_json(res)
    end
    restaurant.profile
    restaurant

    # ||||| somehow this is accidentally getting called
    # ||||| when searching for restaurant "mayfield"
    # vvvvv and then hits an error on line 34

#     Traceback (most recent call last):
#             6: from bin/run.rb:8:in `<main>'
#     5: from /Users/adamsultanov/Development/mod-1/assignments/module-one-final-project-guide
# lines-nyc-web-career-042219/lib/command_line_interface.rb:79:in `main_menu'
#         4: from /Users/adamsultanov/Development/mod-1/assignments/module-one-final-project-guide
# lines-nyc-web-career-042219/lib/app/user.rb:35:in `favorite_restaurants'
#         3: from /Users/adamsultanov/Development/mod-1/assignments/module-one-final-project-guide
# lines-nyc-web-career-042219/lib/command_line_interface.rb:157:in `favorite_menu'
#         2: from /Users/adamsultanov/Development/mod-1/assignments/module-one-final-project-guide
# lines-nyc-web-career-042219/lib/app/user.rb:35:in `favorite_restaurants'
#         1: from /Users/adamsultanov/Development/mod-1/assignments/module-one-final-project-guide
# lines-nyc-web-career-042219/lib/command_line_interface.rb:173:in `favorite_menu'
# /Users/adamsultanov/Development/mod-1/assignments/module-one-final-project-guidelines-nyc-web-ca
# reer-042219/lib/app/user.rb:34:in `favorite_restaurants': undefined method `<' for nil:NilClass
# (NoMethodError)

    # i think its because there is no error handling for
    # if the restaurant is both 1.not in our database
    # and 3.not in the DOH api

    # im tired...

  when "2"
    user.favorite_restaurants
  when "3"
    exit # mystery!
  when "4"
    exit
  when "exit"
    exit
  else
    main_menu(user)
  end
end

def restaurant_prompt
  puts ""
  puts "Which restaurant would you like to check out?"
  print "> "

  restaurant = get_input
  if restaurant == ""
    restaurant_prompt
  end
  restaurant
end

def restaurant_menu(user, restaurant)
  puts ""
  puts "Options:"
  puts "1. Add to Favorites"
  puts "2. View Favorites"
  puts "3. Exit to Main Menu"
  puts "Please enter a number"
  print "> "

  option = get_input
  case option
  when "1"
    user.add_to_favorites(restaurant)
  when "2"
    puts ""
    puts "View Favorites"
    puts "**************"
    puts user.favorite_restaurants
  when "3" || "exit"
    puts ""
    puts "Exit to main menu"
    puts "*****************"
    main_menu(user)
  else
    "Please enter a number from the menu"
  end
end

def favorite_menu(fav)
  puts ""
  puts "Restaurant: #{fav.restaurant.name}"
  puts "Cuisine: #{fav.restaurant.cuisine}"
  puts "Latest Grade: [ #{fav.restaurant.latest_inspection.grade} ] on #{fav.restaurant.latest_inspection.date}"
  puts "My Rating: #{fav.my_rating}"
  puts ""
  puts "Options:"
  puts "1. Edit Rating"
  puts "2. Delete Favorite"
  puts "3. Back to Favorites Menu"
  puts "4. Exit to Main Menu"
  print "> "

  option = get_input
  case option
  when "1"
    puts ""
    puts "Enter a new rating number"
    print "> "

    new_rating = get_input
    fav.update_attribute(:my_rating, new_rating)
    puts ""
    puts "Rating updated to #{fav.my_rating}"
    puts "*****************"

    returner = get_input
    fav.user.favorite_restaurants if returner
  when "2"
    puts ""
    puts "Are you sure? [ Y / N ]"
    print "> "

    sure = get_input
    if sure.upcase == "Y"
      Favorite.delete(self.id)
      puts "Favorite deleted"
      puts "****************"

      returner = get_input
      fav.user.favorite_restaurants if returner
    else
      favorite_menu(fav)
    end
  when "3"
    fav.user(favorite_restaurants)
  when "4"
    main_menu(fav.user)
  else
    puts "Please enter a number from the menu"
  end
end

def exit
  puts "Bye bye!!!"
  exit!
end
