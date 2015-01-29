module RailsSpreadsheetReader

  class RowCollection

    attr_accessor :invalid_row, :rows

    def initialize
      self.rows = []
    end

    def push(row)
      self.invalid_row = row unless row.valid?
      self.rows << row
    end

    def valid?
      self.invalid_row.nil?
    end

    def errors
      self.invalid_row.errors
    end

    def set_invalid_row(row, model_with_errors)
      row.copy_errors(model_with_errors)
      self.invalid_row = row
    end

  end

end