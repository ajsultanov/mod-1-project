class Restaurant < ActiveRecord::Base

  has_many :favorites
  has_many :users, through: :favorites
  has_many :inspections
  has_many :violations, through: :inspections



  def latest_inspection
    self.inspections.first
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
  end

  def inspection_history
    self.inspections.order(date: :desc).each.with_index do |inspection, i|
      puts "#{i+1}. Grade: #{inspection.grade} - Inspection Date: #{inspection.date}"
    end
  end

  def worst_violation
    worst_inspection = self.inspections.order(score: :desc).first
    worst_inspection.grade
    worst_inspection.score
    worst_inspection.violation.description
    puts "Grade: #{worst_inspection.grade}"
    puts "Score: #{worst_inspection.score}"
    puts "Reason: #{worst_inspection.violation.description}"
  end






end
