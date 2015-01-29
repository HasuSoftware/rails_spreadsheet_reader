class <%= @spreadsheet_name %>Spreadsheet < RailsSpreadsheetReader::Base

  # add the columns you want to read:
  # attr_accessor :attr1, :attr2, :attr3

  # add validations to your fields
  # validates_presence_of :attr1

  # map this model attributes to your spreadsheet attributes
  # you can use a hash { attr1: 0, attr2: 1, attr3: 2, ... }
  # or a array %w(attr1 attr2 attr3 ...)

  def self.columns
    # return { attr1: 0, attr2: 1, ... }
  end

  # set the row number where the data start, default is 2 (1-based)
  def self.starting_row
    2
  end

  def self.validate_multiple_rows(row_collection)
    # This method is called when all rows of row_collection are valid. The main
    # idea of this method is to run validations that have to do with
    # the set of rows of the excel. For example, you can check here if a
    # excel column is unique. It have to raise an exception if there was
    # an error with a certain row.
    #
    # Example:
    #
    # def self.validate_multiple_rows(row_collection)
    #   username_list = []
    #   row_collection.rows.each do |row|
    #     if username_list.include?(row.username)
    #       row_collection.invalid_row = row
    #       row.errors[:username] = 'is unique'
    #       raise 'Validation Error'
    #     else
    #       username_list << row.username
    #     end
    #   end
    # end
    #
  end

  def self.persist(row_collection)
    # This method is called after the self.validate_multiple_rows method
    # only if it have not raised an exception. The idea of this method
    # is to persist the row's data. If there was an error with a certain
    # row, you have to Rollback the valid transactions, set the
    # invalid error to the row_collection and set the row errors to the
    # row object.
    #
    # Example:
    # def self.persist(row_collection)
    #   User.transaction do
    #     row_collection.rows.each do |row|
    #       user = User.new(row.as_json)
    #       unless user.save
    #         row_collection.set_invalid_row(row, user) # pass the model with errors as second parameter
    #         rollback # use the rollback helper to rollback the transaction.
    #       end
    #     end
    #   end
    # end
  end

end