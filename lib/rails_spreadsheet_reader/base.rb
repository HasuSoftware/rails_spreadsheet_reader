require 'active_model'
require 'rails'
require 'roo'

module RailsSpreadsheetReader

  class Base

    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    class MethodNotImplementedError < StandardError; end
    class InvalidTypeError < StandardError; end

    attr_accessor :row_number
    attr_accessor :record_with_error
    attr_accessor :copied_errors
    attr_accessor :collection

    BASE_ATTRIBUTES = %w(row_number record_with_error copied_errors collection)

    validate :check_record_with_error

    def check_record_with_error
      if record_with_error.present? and record_with_error.errors.any?
        record_with_error.errors.full_messages.each do |msg|
          @errors.add(:base, msg)
        end
      end
    end

    def self.last_record
      @last_record ||= nil
    end

    def self.last_record=(record)
      @last_record = record
    end

    def models
      fail(
          MethodNotImplementedError,
          'Please implement this method in your class.'
      )
    end

    def persist
      models = self.class.models.is_a?(Array) ? self.class.models : [self.class.models]
      models.each do |model|
        method_name = model.model_name.human.downcase
        if respond_to?(method_name)
          instance = model.new(send(model.model_name.human.downcase))
        else
          instance = model.new(as_json(except: BASE_ATTRIBUTES))
        end
        instance.save!
      end
    end

    # Defines the starting row of the excel where the class should start reading the data.
    #
    # == Returns:
    # A integer representing the starting row of the data.
    #
    def self.starting_row
      2
    end

    # Defines the columns of the excel that the class will read. This method must return
    # a Array of strings/symbols (representing columns names) or a Hash (which map column names to columns indexes).
    #
    # Array Example
    #   def self.headers
    #     [:username, :email, :gender]
    #   end
    #
    # Hash Example
    #   def self.headers
    #     { :username => 0, :email => 1, :gender => 2 }
    #   end
    #
    # == Returns:
    # An Array or a Hash defining the columns of the excel.
    #
    def self.headers
      fail(
          MethodNotImplementedError,
          'Please implement this method in your class.'
      )
    end

    # Returns the Hash representation of a given array using self.format method
    # (which internally uses self.columns). The keys of this Hash are defined
    # in the self.columns method and the values of each key depends on the
    # order of the columns.
    #
    # For example, given the following self.columns definition
    #   def self.headers
    #     [:username, :email, :gender]
    #   end
    # Or
    #   def self.headers
    #     { :username => 0, :email => 1, :gender => 2 }
    #   end
    # Row.formatted([username email@test.cl male]) will return
    # { username: 'username', email: 'email@test.cl', gender: 'male' }
    #
    # == Parameters:
    # array::
    #   Array of values which represents an excel column.
    #
    # == Returns:
    # Hash representation of the given array which maps columns names to the array values.

    def self.formatted_hash(array)

      if format.keys.count > 0
        parsed_row = {}
        format.each_pair { |key, col| parsed_row[key] = array[col] }
        return parsed_row
      end

      return nil
    end

    # Generalizes the constructor of ActiveModel::Model to make it work
    # with an array argument.
    # When an array argument is passed, it calls formatted_hash method
    # to generate a Hash and then pass it to the ActiveModel::Model constructor
    #
    # == Parameters:
    # arr_or_hash::
    #   Array or Hash of values which represents an excel column.

    def initialize(arr_or_hash = {})
      self.copied_errors = ActiveModel::Errors.new(self)
      if arr_or_hash.is_a?(Array)
        super(self.class.formatted_hash(arr_or_hash))
      else
        super(arr_or_hash)
      end
    end

    # Persist all rows of collection if they all are valid
    #
    # == Parameters:
    # row_collection::
    #   SpreadsheetReader::RowCollection instance
    def self.persist(collection)
      if collection.valid?
        ActiveRecord::Base.transaction do
          collection.each do |row|
            # If any of validations fail ActiveRecord::RecordInvalid gets raised.
            # If any of the before_* callbacks return false the action is cancelled and save! raises ActiveRecord::RecordNotSaved.
            begin
              row.persist
            rescue ActiveRecord::RecordInvalid => e
              row.record_with_error = e.record
              collection.invalid_row = row
              rollback
            rescue ActiveRecord::RecordNotSaved => e
              row.model_with_error = e.record
              collection.invalid_row = row
              rollback
            end
          end
        end
      end
    end

    def self.open(spreadsheet_file)
      Roo::Spreadsheet.open(spreadsheet_file)
    end

    # Read and validates the given #spreadsheet_file. Persistence is triggered
    # after all validation pass
    #
    # == Parameters:
    # spreadsheet_file::
    #   File instance
    # == Returns:
    # row_collection::
    #   SpreadsheetReader::RowCollection instance
    def self.read(spreadsheet_file)

      if headers.empty?
        raise MethodNotImplementedError
      end

      spreadsheet = open(spreadsheet_file)
      collection = RailsSpreadsheetReader::RowCollection.new

      # Populate collection
      (starting_row..spreadsheet.last_row).each do |row_number|
        parameters = formatted_hash(spreadsheet.row(row_number))
        parameters[:row_number] = row_number
        parameters[:collection] = collection
        collection << self.new(parameters)
      end

      # Validation and persist
      persist(collection)

      collection
    end

    # Transform an array [a0, a1, a2, ...] to a Hash { a0 => 0, a1 => 1, etc }
    # which is the format required by the #formatted_hash method.
    def self.array_to_hash(arr)
      Hash[[*arr.map { |e| e.to_sym }.map.with_index]]
    end

    private

    # Returns the Hash representation of the defined columns
    def self.format

      if headers.is_a?(Array) or headers.is_a?(Hash)
        return headers.is_a?(Array) ? array_to_hash(headers) : headers
      end

      fail(
          InvalidTypeError,
          'Please check that the self.columns implementation returns a instance of Hash or Array.'
      )

    end

    # Helper for rollbacks inside #after_multiple_row_validations
    def self.rollback
      raise ActiveRecord::Rollback
    end

  end

end
