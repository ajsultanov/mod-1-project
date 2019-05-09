require 'rest-client'
require 'json'
require 'pry'

def populate_db_from_json(restaurant)

  response_string = RestClient.get("https://data.cityofnewyork.us/resource/43nn-pn8j.json?dba=#{restaurant.upcase}")
  response_hash = JSON.parse(response_string)
  restaurant_inspections = response_hash

  binding.pry

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
      if !restaurant.exists?
        restaurant = Restaurant.new
        restaurant.name = inspection["dba"]
      
        restaurant.address = "#{inspection} " + "#{first_inspection[12]}"
        restaurant.zipcode = first_inspection[13]
        restaurant.cuisine = first_inspection[15]
        restaurant.save
      end

  violation = Violation.new
  violation.code = first_inspection[18]
  violation.description = first_inspection[19]
  violation.critical = first_inspection[20]
  violation.save

  inspection = Inspection.new
  inspection.grade = first_inspection[-4]
  inspect_date = first_inspection[-3]
  year = inspect_date[0..3]
  month = inspect_date[5..6]
  day = inspect_date[8..9]
  inspection.date = "#{month}/" + "#{day}/" + "#{year}"
  score_as_integer = first_inspection[21].to_i
  inspection.score = score_as_integer
  inspection.restaurant_id = restaurant.id
  inspection.violation_id = violation.id
  inspection.save

  restaurant
  end
