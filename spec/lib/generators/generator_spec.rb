# spec/lib/generators/test/test_generator_spec.rb

require "generator_spec"
require_relative '../../../lib/generators/rails/spreadsheet_generator'

describe Rails::Generators::SpreadsheetGenerator, type: :generator do

  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(name -m User)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates a test initializer" do
    expect(destination_root).to have_structure do
      directory 'app' do
        directory 'spreadsheet_reader' do
          file 'name_spreadsheet.rb' do
            contains 'class NameSpreadsheet'
          end
        end
      end
    end
  end

end