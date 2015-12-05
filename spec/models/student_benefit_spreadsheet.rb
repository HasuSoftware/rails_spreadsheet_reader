class StudentBenefitSpreadsheet < RailsSpreadsheetReader::Base

  attr_accessor :student_name, :benefit_name, :code

  validates_presence_of :student_name, :benefit_name, :code

  def self.headers
    %w(student_name benefit_name code)
  end

  def self.models
    [Student, Benefit]
  end

  def student
    { name: student_name, code: code }
  end

  def benefit
    { name: benefit_name, code: code }
  end

end