class Restaurant < ActiveRecord::Base

  has_many :favorites
  has_many :users, through: :favorites
  has_many :inspections
  has_many :violations, through: :inspections

  def latest_inspection
    self.inspections.order(date: :desc).first
  end

  def profile
    puts "************************"
    puts "      PROFILE"
    puts "************************"
    puts ""
    puts "#{self.name}"
    puts "#{self.address}, #{self.zipcode}"
    puts ""
    puts "************************"
    puts "Grade: #{self.latest_inspection.grade} - Inspection Date: #{self.latest_inspection.date}"
    puts "************************"
    history = inspection_history
    puts history[1...10]
  end

  def inspection_history
    history = []
    self.inspections.order(date: :desc).each.with_index do |inspection, i|
      history << "#{i+1}. Grade: #{inspection.grade} - Date: #{inspection.date} - Code: #{inspection.violation.code}"
    end
    history
  end

  def worst_violation
    worst_inspection = self.inspections.order(score: :desc).first
      if worst_inspection.score > 12
        puts "HERE'S THE DIRT:"
      else
        puts "HERE'S THE SCOOP:"
      end
    puts ""
    puts "Grade: #{worst_inspection.grade}"
    puts ""
    puts "Score: #{worst_inspection.score}"
    puts ""
    puts "Reason: #{worst_inspection.violation.description}"

  end

end
