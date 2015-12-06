class UserInvalidSpreadsheet < RailsSpreadsheetReader::Base

  attr_accessor :username, :email, :gender

  validates_presence_of :username

  def self.columns
    { :username => 0, :email => 1, :gender => 2 }
  end

  def self.validate_multiple_rows(row_collection)
    usernames = {}
    row_collection.rows.each do |row|
      if usernames.has_key?(row.username)
        row_collection.invalid_row = row
        row.errors[:username] = 'is unique'
        break
      else
        usernames[row.username] = true
      end
    end
  end

end