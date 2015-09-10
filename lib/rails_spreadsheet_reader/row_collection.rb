module RailsSpreadsheetReader

  class RowCollection

    attr_accessor :invalid_row, :rows

    def initialize
      self.rows = []
    end

    def push(row)
      self.invalid_row = row if row.invalid?
      self.rows << row
    end

    def invalid_row=(row)
      if row.invalid?
        @invalid_row = row
      end
      # TODO: Throw exception maybe?
    end

    def valid?
      self.invalid_row.nil?
    end

    def invalid?
      !valid?
    end

    def errors
      self.invalid_row.errors if invalid?
    end

    def set_invalid_row(row, model_with_errors)
      row.copy_errors(model_with_errors)
      self.invalid_row = row
    end

    def each(&block)
      self.rows.each(&block)
    end

  end

end