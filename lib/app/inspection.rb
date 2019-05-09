class Inspection < ActiveRecord::Base


  belongs_to :restaurant
  belongs_to :violation

  def yuck_my_yum
    self.populate_yuck_from_json
  end

end
