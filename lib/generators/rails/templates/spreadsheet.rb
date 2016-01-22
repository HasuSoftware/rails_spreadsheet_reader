class <%= @spreadsheet_name %>Spreadsheet < RailsSpreadsheetReader::Base

  # Add alias names for excel columns
  # attr_accessor <%= @attributes.map{|a| ":#{a}"}.join(', ') %>

  # Add validation for your fields
  # validates_presence_of :attr1

  # Map attributes to your spreadsheet columns (0-based).
  # You can use a hash { attr1: 0, attr2: 1, attr3: 2, ... }
  # or an array %w(attr1 attr2 attr3 ...) (which maps each key to their index).
  def self.headers
    {<%= @attributes.map.with_index{|a,i| "#{a}: #{i}"}.join(', ') %>}
  end

  # Set the row number where the data start, default is 2 (1-based)
  def self.starting_row
    2
  end

  # Returns 1 or more ActiveRecord classes where data will be saved
  def self.models
    [<%= @models.count == 1 ? @models.first : @models.join(', ') %>]
  end

  # Map a spreadsheet instance to model parameters
  <% @models.each do |model| %>
  def <%= model.downcase %>
    # Returns { attr1: self.attr1, attr2: self.attr2 }
  end
  <% end %>

  # Persist
  #def persist!!
    # create! or save! your records. By default, it will use your methods
    # defined above (<%= @models.map{|m| m.downcase}.join(', ') %>)
  #end

end