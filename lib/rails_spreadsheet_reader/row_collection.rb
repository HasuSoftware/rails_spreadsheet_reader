module RailsSpreadsheetReader

  class RowCollection

    attr_accessor :invalid_row, :rows

    def initialize
      self.rows = []
    end

    def <<(row)
      self.rows << row
    end

    def invalid_rows
      rows.reject(&:valid?)
    end

    def valid?
      invalid_rows.empty?
    end

    def invalid?
      !valid?
    end

    def errors
      invalid? ? invalid_rows.map(&:errors).flatten : []
    end

    def each(&block)
      self.rows.each(&block)
    end

    def count
      self.rows.count
    end

  end

end