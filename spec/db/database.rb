require 'sqlite3'
require 'active_record'

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: ':memory:'
)

# Drop tables
connection = ActiveRecord::Base.connection
connection.tables.each do |table|
  connection.drop_table(table)
end

# Define a minimal database schema
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :email
    t.string :username
    t.string :name
    t.string :gender
  end
end

# Define the models
class User < ActiveRecord::Base
  validates_presence_of :email, :username
  validates_uniqueness_of :username, :email

  def self.make_valid
    User.new(username: 'username', email: 'username@example.com')
  end

  def self.make_invalid
    User.new(username: 'username')
  end

end