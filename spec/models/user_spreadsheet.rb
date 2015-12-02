class UserSpreadsheet < RailsSpreadsheetReader::Base

  attr_accessor :username, :email, :gender, :name

  validates_presence_of :username, :email

  def self.headers
    { :username => 0, :email => 1, :gender => 2 }
  end

  def self.models
    User
  end

  def make_invalid
    self.model_with_error = User.make_invalid
  end

end