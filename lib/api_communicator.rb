require 'rest-client'
require 'json'
require 'pry'

def get_restaurant_violations(restaurant)
response_string = RestClient.get('https://data.cityofnewyork.us/api/views/43nn-pn8j/rows.json?accessType=DOWNLOAD')
  response_hash = JSON.parse(response_string)
  # response_array = response_hash

  restaurant_inspections = response_hash["data"]
  #array of all restaurant inspections

  restaurant_inspections.each do |restaurant_inspection|
    if restaurant_inspection[9] == restaurant
      restaurant_name = restaurant_inspection[9]
      restaurant_address = restaurant_inspection[11], restaurant_inspection[12]
      # restaurant_address.join(' ')
      restaurant_zipcode = restaurant_inspection[13]
      restaurant_cuisine = [15]
      inspection_rating = restaurant_inspection[-4]
      inspection_date = restaurant_inspection[-3]
      puts ""
      puts ""
      puts "#{restaurant_name}"
      puts ""
      puts "#{restaurant_address}, #{restaurant_zipcode}"
      puts ""
      puts "*" * 20
      puts ""
      puts "#{inspection_rating} - #{inspection_date}"
      puts ""
      puts "*" * 20
      puts ""
    end
    if restaurant_inspection[9]
      if restaurant.upcase! == restaurant_inspection[9]
          puts "#{restaurant_inspection[-4]}"
      end
    else
      "there is no restaurant by that name"
    end
    # binding.pry
  end

end

 #response_hash["data"] = array of all inspections
 #response_hash["data"][9] = name of restaurant
  #response_hash["data"][-4] = letter grade
 #response_hash["data"][0][-3] = inspection datetime

 # restaurant_inspection_array[0] = Row ID
 # restaurant_inspection_array[1] = ?
 # restaurant_inspection_array[2] = ?
 # restaurant_inspection_array[3] = ?
 # restaurant_inspection_array[4] = ?
 # restaurant_inspection_array[5] = ?
 # restaurant_inspection_array[6] = ?
 # restaurant_inspection_array[7] = ?
 # restaurant_inspection_array[8] = CAMIS Number
      # restaurant_inspection_array[9] = Restaurant Name
 # restaurant_inspection_array[10] = Borough
      # restaurant_inspection_array[11] = Address Building No.
      # restaurant_inspection_array[12] = Address Street
      # restaurant_inspection_array[13] = Zipcode
 # restaurant_inspection_array[14] = Phone
      # restaurant_inspection_array[15] = Cuisine
# GRP    # restaurant_inspection_array[16] = Inspection Date
 # restaurant_inspection_array[17] = Action
      # restaurant_inspection_array[18] = Violation Code
      # restaurant_inspection_array[19] = Violation Desc.
 # restaurant_inspection_array[20] = Critical Flag
 # restaurant_inspection_array[21] = Score
      # restaurant_inspection_array[22] = Grade
 # restaurant_inspection_array[23] = Grade Date
 # restaurant_inspection_array[24] = Record Date
 # restaurant_inspection_array[25] = Inspection Type
 # restaurant_inspection_array[26] = ?
 # restaurant_inspection_array[27] = ?
