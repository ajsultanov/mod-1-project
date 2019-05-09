require 'rest-client'
require 'json'
require 'pry'

def populate_db_from_json(restaurant, user)

  response_string = RestClient.get("https://data.cityofnewyork.us/resource/43nn-pn8j.json?dba=#{restaurant.upcase}")
  response_hash = JSON.parse(response_string)
  restaurant_violations = response_hash



  if restaurant_violations == []
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

  restaurant_violations.each do |violation|
     restaurant = violation["dba"]
      if !Restaurant.exists?(name: restaurant)
        r = Restaurant.new({
        name: violation["dba"],
        address: "#{violation["building"]} " + "#{violation["street"]}",
        zipcode: violation["zipcode"],
        cuisine: violation["cuisine_description"]
        })
        r.save
      # else
      #   r = restaurant
      end

    v = Violation.new({
      code: violation["violation_code"],
      description: violation["violation_description"],
      critical: violation["critical_flag"]
      })
    v.save

    #parsing string data for inspection
    i_date = violation["inspection_date"]
    year = i_date[0..3]
    month = i_date[5..6]
    day = i_date[8..9]
    score_as_integer = violation["score"].to_i

    #parsing string data for inspection
    violation["grade"] != nil ? g = violation["grade"] : g = "NOT PRESENT"

    i = Inspection.new({
      grade: "#{g}",
      date: "#{month}/" + "#{day}/" + "#{year}",
      score: score_as_integer,
      restaurant_id: restaurant.id,
      violation_id: v.id
      })
      #inspection is nil if the restaurant fails
      #changed to i because we're iterating over inspection above
      #variables need cleaning up
    i.save


  end
  restaurant
end
