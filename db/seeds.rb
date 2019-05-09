
resto1 = Restaurant.create(
  :name=>"Cool Restaurant",
  :address=>"101 Bulwark Ave.",
  :zipcode=>10001,
  :cuisine=>"American"
)
resto2 = Restaurant.create(
  :name=>"Fancy Restaurant",
  :address=>"123 Fake Street",
  :zipcode=>10011,
  :cuisine=>"French"
)

user1 = User.create(
  :name=> "Adam"
)
user2 = User.create(
  :name=> "Henry"
)

viol1 = Violation.create(
  :code => "10F",
  :description=> "rat dung",
  :critical => true
)
viol2 = Violation.create(
  :code => "04L",
  :description=> "floormeats",
  :critical => true
)

fav1 = Favorite.create(
  :user_id => 1,
  :restaurant_id => 1,
  :my_rating => 3
)
fav2 = Favorite.create(
  :user_id => 2,
  :restaurant_id => 2,
  :my_rating => 5
)

insp1 = Inspection.create(
  :restaurant_id=> 1,
  :violation_id=> 1,
  :date=> "April 14, 2005",
  :grade=> "Z"
)
insp2 = Inspection.create(
  :restaurant_id=> 8,
  :violation_id=> 8,
  :date=> "May 3, 2008",
  :grade=> "A"
)
insp3 = Inspection.create(
  :restaurant_id=> 7,
  :violation_id=> 7,
  :date=> "August 7, 2007",
  :grade=> "B"
)
