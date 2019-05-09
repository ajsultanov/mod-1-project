require 'rest-client'
require 'json'
require 'pry'

def populate_db_from_json(restaurant, user)

  response_string = RestClient.get("https://data.cityofnewyork.us/resource/43nn-pn8j.json?dba=#{restaurant.upcase}")
  response_hash = JSON.parse(response_string)
  restaurant_violations = response_hash

  first_hash = restaurant_violations.first

    if restaurant_violations == []
      puts "RESTAURANTNTNT NOOOOOOOO"
      main_menu(user)
    end

  if !Restaurant.exists?(name: restaurant)
    r = Restaurant.create({
    name: first_hash["dba"],
    address: "#{first_hash["building"]} " + "#{first_hash["street"]}",
    zipcode: first_hash["zipcode"],
    cuisine: first_hash["cuisine_description"]
    })
  end

  restaurant_violations.each do |violation|
    v = Violation.create({
      code: violation["violation_code"],
      description: violation["violation_description"],
      critical: violation["critical_flag"]
      })


    #parsing string data for inspection
    i_date = violation["inspection_date"]
    year = i_date[0..3]
    month = i_date[5..6]
    day = i_date[8..9]
    score_as_integer = violation["score"].to_i

    #parsing string data for inspection
    violation["grade"] != nil ? g = violation["grade"] : g = "???"


    i = Inspection.create({
      grade: "#{g}",
      date: "#{year}/#{month}/#{day}",
      score: score_as_integer,

      restaurant_id: r.id,
      violation_id: v.id
      })
      #inspection is nil if the restaurant fails
      #changed to i because we're iterating over inspection above
      #variables need cleaning up



  end
  r
end
