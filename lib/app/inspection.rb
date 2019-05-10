class Inspection < ActiveRecord::Base


  belongs_to :restaurant
  belongs_to :violation

  

end
