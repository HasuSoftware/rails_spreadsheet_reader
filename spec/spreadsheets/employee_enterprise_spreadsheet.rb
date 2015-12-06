class EmployeeEnterpriseSpreadsheet < RailsSpreadsheetReader::Base

  attr_accessor :employee_name, :enterprise_name
  validates_presence_of :employee_name, :enterprise_name

  def self.headers
    %w(employee_name enterprise_name)
  end

  def self.models
    [Enterprise, Employee]
  end

  def employee
    { name: employee_name, enterprise: Enterprise.find_by(name: enterprise_name) }
  end

  def enterprise
    { name: enterprise_name }
  end

end