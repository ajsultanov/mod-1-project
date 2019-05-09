require 'rest-client'
require 'json'
require 'pry'

def populate_db_from_json(restaurant, user)

  response_string = RestClient.get("https://data.cityofnewyork.us/resource/43nn-pn8j.json?dba=#{restaurant.upcase}")
  response_hash = JSON.parse(response_string)
  restaurant_inspections = response_hash

  if restaurant_inspections = []
    puts "RESTAURANTNTNT NOOOOOOOO"
    main_menu(user)
  end

  # selected_inspections = restaurant_inspections.select do |r|
  #   r[9] == restaurant.upcase
  # end
  #
  # first_inspection = selected_inspections
  #
  # first_inspection.each do |inspection|
  #   r[9] == restaurant.upcase
  #   if restaurant.exists?

  restaurant_inspections.each do |inspection|
    restaurant = inspection["dba"]
    #if !restaurant.exists
    restaurant = Restaurant.new({
    name: inspection["dba"],
    address: "#{inspection["building"]} " + "#{inspection["street"]}",
    zipcode: inspection["zipcode"],
    cuisine: inspection["cuisine_description"]
    })
    restaurant.save
    #end




    #  end

    violation = Violation.new({
      code: inspection["violation_code"],
      description: inspection["violation_description"],
      critical: inspection["critical_flag"]
      })
    violation.save

    i_date = inspection["inspection_date"]
    year = i_date[0..3]
    month = i_date[5..6]
    day = i_date[8..9]
    score_as_integer = inspection["score"].to_i

    i = Inspection.new({
      grade: inspection["grade"],
      date: "#{month}/" + "#{day}/" + "#{year}",
      score: score_as_integer,
      restaurant_id: restaurant.id,
      violation_id: violation.id
      })
      #inspection is nil if the restaurant fails
      #changed to i because we're iterating over inspection above
      #variables need cleaning up
    i.save


    restaurant
  end

end
