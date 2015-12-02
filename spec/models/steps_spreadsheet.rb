class StepsSpreadsheet < RailsSpreadsheetReader::Base

  #validate_rows(spreadsheet, row_collection)
  #validate_multiple_rows(row_collection) if row_collection.valid?
  #persist(row_collection) if row_collection.valid?

  @@step = :none

  def make_invalid

  end

  def self.validate_rows
    @@step = :validate_rows
  end

  def self.validate_multiple_rows
    @@step = :validate_multiple_rows
  end

  def self.persist
    @@step = :persist
  end

end