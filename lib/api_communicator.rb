require 'rest-client'
require 'json'
require 'pry'

def populate_db_from_json(restaurant, user)

  response_string = RestClient.get("https://data.cityofnewyork.us/resource/43nn-pn8j.json?dba=#{restaurant.upcase}")
  response_hash = JSON.parse(response_string)
  restaurant_violations = response_hash

  #backstop for empty/wrong dba value
  if restaurant_violations == []
    puts "Sorry, we couldn't find that restaurant!"
    main_menu(user)
  end
                                                                                #CREATE RESTAURANT
  first_hash = restaurant_violations.first

  if !Restaurant.exists?(name: restaurant)
    r = Restaurant.create({
      name: first_hash["dba"],
      address: "#{first_hash["building"]} " + "#{first_hash["street"]}",
      zipcode: first_hash["zipcode"],
      cuisine: first_hash["cuisine_description"]
      })
  end
                                                                                #LINK VIOLATIONS TO RESTAURANT
  restaurant_violations.each do |violation|
    v = Violation.create({
      code: violation["violation_code"],
      description: violation["violation_description"],
      critical: violation["critical_flag"]
      })

    #parsing string data for inspection date and score
    i_date = violation["inspection_date"]
    year = i_date[0..3]
    month = i_date[5..6]
    day = i_date[8..9]
    score_as_integer = violation["score"].to_i

    #backstop for empty grade value
    violation["grade"] != nil ? g = violation["grade"] : g = "???"
                                                                                #LINK INSPECTIONS TO RESTAURANT
    i = Inspection.create({
      grade: "#{g}",
      date: "#{year}/#{month}/#{day}",
      score: score_as_integer,
      restaurant_id: r.id,
      violation_id: v.id
      })

  end
  r

end
                                                                                #Quirky Feature
def retrieve_yuck_from_json

  response_string = RestClient.get("https://data.cityofnewyork.us/resource/43nn-pn8j.json?$where=score > 100")
  response_hash = JSON.parse(response_string)
  worst_violations = response_hash

  #select and puts random violation
  random_hash = worst_violations.sample
  puts "Restaurant: #{random_hash["dba"]}"
  puts ""
  puts "Inspection score: #{random_hash["score"]}"
  puts ""
  puts "Violation code: #{random_hash["violation_code"]}"
  puts ""
  puts "Reason: #{random_hash["violation_description"]}"

end
