class UserSpreadsheet < RailsSpreadsheetReader::Base

  attr_accessor :username, :email, :gender

  validates_presence_of :username, :email

  def self.columns
    { :username => 0, :email => 1, :gender => 2 }
  end

  def make_invalid
    errors[:username] = 'is invalid'
  end

end