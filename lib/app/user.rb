class User < ActiveRecord::Base

  has_many :favorites
  has_many :restaurants, through: :favorites

  def favorite_restaurants
    puts ""
    puts "Favorites"
    puts "*********"

    if favorites.length > 0
      self.favorites.each.with_index do |fav, i|
        puts "#{i+1}. #{fav.restaurant.name}"
      end
      puts ""
      puts "Enter a Number to Edit a Favorite"
      puts "or Type \'exit\' to Go to the Main Menu"
      print "> "
    else
      puts "You don't have any favorites yet!"
      puts "Press any key to return"

      returner = get_input
      main_menu(self) if returner
    end

    option = gets.chomp
    if option.downcase == "exit"
      main_menu(self)
    elsif /\D/.match(option)
      puts "Please enter a number"
      favorite_restaurants
    elsif /\d/.match(option)
      option_num = option.to_i - 1

      if option_num < favorites.count
        favorite_menu(favorites[option_num])
      else
        puts "Please enter a valid option"
        favorite_restaurants
      end

    end
  end

  def add_to_favorites(restaurant)
    if Favorite.exists?({user_id: self.id, restaurant_id: restaurant.id})
      puts "You have already added this restaurant as a favorite"
      puts "******************"
      puts "Press any key to return"

      returner = get_input
      main_menu(self) if returner
    else
      Favorite.create({user_id: self.id, restaurant_id: restaurant.id})
      self.reload
      puts "Added to favorites"
      puts "******************"
      puts "Press any key to return"

      returner = get_input
      main_menu(self) if returner
    end
  end



end
