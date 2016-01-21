require 'spec_helper'
require_relative 'spreadsheets/invalid_column_spreadsheet'
require_relative 'spreadsheets/user_spreadsheet'
require_relative 'spreadsheets/user_invalid_spreadsheet'
require_relative 'spreadsheets/empty_column_spreadsheet.rb'

describe RailsSpreadsheetReader::RowCollection do

  it 'New collection should be empty' do
    collection = RailsSpreadsheetReader::RowCollection.new
    expect(collection.rows).to eq([])
    expect(collection.invalid?).to eq(false)
    expect(collection.valid?).to eq(true)
    expect(collection.errors).to eq([])
  end

  it 'Pushed rows should be saved into the collection' do
    collection = RailsSpreadsheetReader::RowCollection.new
    row = UserSpreadsheet.new
    collection << row
    expect(collection.rows.count).to eq(1)
    expect(collection.rows.first).to eq(row)
  end

  it 'A collection with an invalid row should be invalid' do
    collection = RailsSpreadsheetReader::RowCollection.new
    row = UserSpreadsheet.new
    row.make_invalid
    expect(row.invalid?).to eq(true)
    collection << row
    expect(collection.valid?).to eq(false)
    expect(collection.invalid?).to eq(true)
  end

end