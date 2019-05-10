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


def main_menu(user)                                # MAIN MENU START
  puts ""
  puts "Welcome to the D.O.H.-Jo"
  puts "[ #{user.name} ]"
  puts "************************"
  puts "      MAIN MENU"
  puts "************************"
  puts ""
  puts "Options:"
  puts ""
  puts "1. Search the Restaurant Database!"
  puts "2. View My Favorites List"
  puts "3. Feeling Lucky???"
  puts "4. Exit the Program"
  print "> "

  option = get_input
  case option
  when "1"
    res = restaurant_prompt
    restaurant = Restaurant.find_by(name: res.upcase)
    if restaurant == nil
      restaurant = populate_db_from_json(res, user)
    end
    restaurant.profile

    restaurant_menu(user, restaurant)

  when "2"
    user.favorite_restaurants

  when "3"
    puts ""
    puts "Let's roll the dice!"
    puts "************************"
    user.yuck_my_yum
    #rename this

  when "4"
    exit

  when "exit"
    exit

  else
    main_menu(user)

  end
end                                                # MAIN MENU END

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

def restaurant_menu(user, restaurant)              # RESTAURANT MENU START
  puts ""
  puts "Options:"
  puts "1. Add to Favorites"
  puts "2. View Favorites"
  puts "3. View Worst Violation"
  puts "4. Exit to Main Menu"
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
    user.favorite_restaurants

  when "3"
    puts ""
    puts "View Worst Violation"
    puts "**************"
    restaurant.worst_violation
    puts ""
    puts "Press return to return to #{restaurant.name}'s profile"

    returner = get_input
    restaurant.profile
    restaurant_menu(user, restaurant) if returner


  when "4" || "exit"
    puts ""
    puts "Exit to main menu"
    puts "*****************"
    main_menu(user)

  else
    "Please enter a number from the menu"
    restaurant_menu(user, restaurant)

  end
end                                                # RESTAURANT MENU END

def favorite_menu(fav)                             # FAVORITE MENU START
  puts ""
  puts "Restaurant: #{fav.restaurant.name}"
  puts "Cuisine: #{fav.restaurant.cuisine}"
  puts "Latest Grade: [ #{fav.restaurant.latest_inspection.grade} ] on #{fav.restaurant.latest_inspection.date}"
  puts "My Rating: #{fav.my_rating}"
  puts ""
  puts "Options:"
  puts "1. Edit Rating"
  puts "2. Delete Favorite"
  puts "3. View Full Inspection History"
  puts "4. Back to Favorites Menu"
  puts "5. Exit to Main Menu"
  print "> "

  option = get_input
  if option == ""
    favorite_menu(fav)
  end
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
    puts "Press return to return to your favorites"

    returner = get_input
    fav.user.favorite_restaurants if returner

  when "2"
    puts ""
    puts "Are you sure? [ Y / N ]"
    print "> "

    sure = get_input
    if sure.upcase == "Y"
      fav.user.favorites.delete(fav.id)
      fav.user.reload
      puts "Favorite deleted"
      puts "****************"
      puts "Press return to return to the main menu"

      returner = get_input
      main_menu(fav.user) if returner
    else
      favorite_menu(fav)
    end

  when "3"
    puts ""
    puts fav.restaurant.inspection_history
    puts "*****************"
    puts "Press any key to return"

    returner = get_input
    favorite_menu(fav) if returner

  when "4"
    fav.user(favorite_restaurants)

  when "5"
    main_menu(fav.user)

  else
    puts "Please enter a number from the menu"
    favorite_menu(fav)
  end
end                                                # FAVORITE MENU END

def exit
  puts "Bye bye!!!"
  exit!
end
