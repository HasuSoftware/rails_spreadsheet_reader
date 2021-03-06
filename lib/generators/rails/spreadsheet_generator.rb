require 'rails/generators'

module Rails
  module Generators
    class SpreadsheetGenerator < ::Rails::Generators::Base
      desc 'Creates a *_spreadsheet model in the app/spreadsheet_reader directory.'

      source_root File.expand_path('../templates', __FILE__)
      argument :name, :type => :string
      class_option :models, type: :array, aliases: '-m', default: ['Model1', 'Model2']
      class_option :simple, default: false
      class_option :attributes, aliases: '-a', default: ['attr1', 'attr2']

      def generate_spreadsheet
        puts 'hola'
        file_prefix = set_filename(name)
        @spreadsheet_name = set_spreadsheet_name(name)
        @models = @options[:models]
        @simple = @options[:simple]
        @attributes = @options[:attributes]
        template 'spreadsheet.rb', "app/spreadsheet_reader/#{file_prefix}_spreadsheet.rb"
      end

      private

      def set_filename(name)
        name.include?('_') ? name : name.to_s.underscore
      end

      def set_spreadsheet_name(name)
        name.include?('_') ? build_name(name) : capitalize(name)
      end

      def build_name(name)
        pieces = name.split('_')
        pieces.map(&:titleize).join
      end

      def capitalize(name)
        return name if name[0] == name[0].upcase
        name.capitalize
      end
    end
  end
end