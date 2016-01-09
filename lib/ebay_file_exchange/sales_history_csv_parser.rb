class SalesHistoryCSVParser

  attr_reader :csv_file

  def initialize(csv_file:)
    raise "File '#{csv_file}' does not exist" if !File.exist?(csv_file)
    @csv_file = csv_file
  end

  def to_s
    "Sales History: '#{csv_file}'"
  end
end
