module RailsSpreadsheetReader

  class RowCollection

    attr_accessor :invalid_row, :rows

    def initialize
      self.rows = []
    end

    def <<(row)
      self.rows << row
    end

    def valid?
      valid = true
      rows.each do |row|
        if row.invalid?
          self.invalid_row = row
          valid = false
          break
        end
      end
      valid
    end

    def invalid?
      !valid?
    end

    def errors
      invalid? ? self.invalid_row.errors : []
    end

    def each(&block)
      self.rows.each(&block)
    end

  end

end