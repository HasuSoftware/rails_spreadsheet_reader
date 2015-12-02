require 'spec_helper'
require_relative 'models/invalid_column_spreadsheet'
require_relative 'models/user_spreadsheet'
require_relative 'models/user_invalid_spreadsheet'
require_relative 'models/empty_column_spreadsheet.rb'

def test_file(filename, ext)
  File.open(File.join TEST_DIR, "#{filename}.#{ext}")
end

describe RailsSpreadsheetReader::Base do

  it 'not implementing columns method should raise an error' do
    expect { RailsSpreadsheetReader::Base.headers }.to raise_error(RailsSpreadsheetReader::Base::MethodNotImplementedError)
  end

  it 'format method should raise an error if columns method is not valid' do
    expect { InvalidColumnSpreadsheet.format }.to raise_error(RailsSpreadsheetReader::Base::InvalidTypeError)
  end

  it 'formatted_hash should raise an error if columns method is not valid' do
    expect { InvalidColumnSpreadsheet.formatted_hash(%w(username email@test.com male)) }.to raise_error(RailsSpreadsheetReader::Base::InvalidTypeError)
  end

  it 'Base.valid? should be true by default' do
    expect(RailsSpreadsheetReader::Base.new.valid?).to eq(true)
  end

  it 'Base.open_spreadsheet should return a Roo::Base instance' do
    file = test_file 'users', :csv
    roo_row = RailsSpreadsheetReader::Base.open file
    expect(roo_row.is_a?(Roo::Base)).not_to eq(false)
  end

  it 'empty headers should raise an error' do
    file = test_file 'users', :csv
    expect { EmptyColumnSpreadsheet.read(file) }.to raise_error(RailsSpreadsheetReader::Base::MethodNotImplementedError)
  end

  it '#formatted_hash should work in a derived class which overrides "headers" method' do
    formatted_hash = UserSpreadsheet.formatted_hash %w(username email@test.com male)
    expect(formatted_hash).to eq({ username: 'username', email: 'email@test.com', gender: 'male' })

    formatted_hash = UserSpreadsheet.formatted_hash %w(username male email@test.com)
    expect(formatted_hash).not_to eq({ username: 'username', email: 'email@test.com', gender: 'male' })
  end

  it '#new from derived class' do
    row = UserSpreadsheet.new(%w(username email@test.com male))
    expect(row.username).to eq('username')
    expect(row.email).to eq('email@test.com')
    expect(row.gender).to eq('male')

    row = UserSpreadsheet.new({ email: 'email@test.com', gender: 'male', username: 'username' })
    expect(row.username).to eq('username')
    expect(row.email).to eq('email@test.com')
    expect(row.gender).to eq('male')
  end

  it '#valid? should work as desired (derived class)' do
    valid_row = UserSpreadsheet.new({ email: 'email@test.com', gender: 'male', username: 'username' })
    expect(valid_row.valid?).to eq(true)

    invalid_row = UserSpreadsheet.new({ gender: 'male', username: 'username' })
    expect(invalid_row.valid?).to eq(false)
  end

  it '#read_spreadsheet should be invalid because a row is not valid' do
    file = test_file 'users_invalid', :csv
    row_collection = UserSpreadsheet.read(file)
    expect(row_collection.valid?).to eq(false)
    expect(row_collection.invalid_row.row_number).to eq(2)
    expect(row_collection.errors.full_messages).to eq(["Email can't be blank"])
  end

  it 'A row with an invalid record should be invalid' do
    row = UserSpreadsheet.new
    invalid_record = User.make_invalid
    row.model_with_error = invalid_record
    expect(row.valid?).to eq(false)
    expect(row.invalid?).to eq(true)
  end

  it 'A row should persist a valid record' do
    params = User.make_valid.as_json
    params.delete('id')
    expect(User.exists?(params)).to eq(false)
    row = UserSpreadsheet.new(params)
    row.persist
    expect(User.exists?(params)).to eq(true)
  end

  it 'A row should fail when persisting an invalid record' do
    params = User.make_invalid.as_json
    params.delete('id')
    UserSpreadsheet.headers
    UserSpreadsheet.models
    row = UserSpreadsheet.new(params)
    expect { row.persist }.to raise_error(ActiveRecord::RecordInvalid)
  end

end