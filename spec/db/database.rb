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
  create_table :students, force: true do |t|
    t.string :code
    t.string :name
  end
  create_table :benefits, force: true do |t|
    t.string :code
    t.string :name
  end
  create_table :employees, force: true do |t|
    t.string :name
    t.references :enterprise
  end
  create_table :enterprises, force: true do |t|
    t.string :name
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

class Student < ActiveRecord::Base
  validates_uniqueness_of :code
  validates_presence_of :code
end

class Benefit < ActiveRecord::Base
  validates_uniqueness_of :code
  validates_presence_of :code
end

class Employee < ActiveRecord::Base
  belongs_to :enterprise
end

class Enterprise < ActiveRecord::Base
  has_many :employees
  validates_presence_of :name
  validates_uniqueness_of :name
end