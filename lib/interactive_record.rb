require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    sql = "pragma table_info(#{table_name})"

    info = DB[:conn].execute(sql)
    column_names = []
    info.each do |row|
      column_names << row["name"]
    end
    column_names.compact
  end

  def initialize **options
    options.each do |key, value|
      send("#{key}=",value)
    end
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    insert = []
    self.class.column_names.map do |row|
      row if !row.empty?
    end.compact.join(", ")
  end

end
