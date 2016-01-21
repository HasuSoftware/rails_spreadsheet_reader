class UserInvalidSpreadsheet < RailsSpreadsheetReader::Base

  attr_accessor :username, :email, :gender, :birthday

  validates_presence_of :username
  validate :uniqueness_of_username

  def self.headers
    { :username => 0, :email => 1, :gender => 2, :birthday => 3 }
  end

  def uniqueness_of_username
    if collection.present?
      detected = collection.rows.find{|r| r.username == self.username and r.row_number < row_number }
      errors.add(:username, "Username already defined in excel at row #{detected.row_number}") if detected.present?
    end
  end

  def to_s
    {username: username, email: email, gender: gender, birthday: birthday}
  end

end