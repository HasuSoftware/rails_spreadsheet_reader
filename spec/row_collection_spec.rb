require 'spec_helper'
require_relative 'models/invalid_column_spreadsheet'
require_relative 'models/user_spreadsheet'
require_relative 'models/user_invalid_spreadsheet'
require_relative 'models/empty_column_spreadsheet.rb'

describe RailsSpreadsheetReader::RowCollection do

  it 'empty properties' do
    collection = RailsSpreadsheetReader::RowCollection.new
    expect(collection.rows).to eq([])
    expect(collection.invalid?).to eq(false)
    expect(collection.valid?).to eq(true)
    expect(collection.errors).to eq(nil)
  end

  it 'push rows' do
    collection = RailsSpreadsheetReader::RowCollection.new
    user_spreadsheet = UserSpreadsheet.new
    collection.push(user_spreadsheet)
    expect(collection.rows.count).to eq(1)
  end

  it 'push invalid rows' do
    collection = RailsSpreadsheetReader::RowCollection.new
    user_spreadsheet = UserSpreadsheet.new
    user_spreadsheet.make_invalid
    expect(user_spreadsheet.invalid?).to eq(true)
    collection.push(user_spreadsheet)
    expect(collection.valid?).to eq(false)
    expect(collection.invalid?).to eq(true)
  end

  it 'set_invalid_row' do
    collection = RailsSpreadsheetReader::RowCollection.new
    row = UserSpreadsheet.new
    model = UserSpreadsheet.new
    model.make_invalid
    collection.push(row)
    collection.set_invalid_row(row, model)
    expect(collection.valid?).to eq(false)
    expect(collection.invalid?).to eq(true)
    expect(collection.invalid_row).to_not eq(nil)
  end

end