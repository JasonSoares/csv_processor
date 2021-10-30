# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "csv_processor"
require "minitest/autorun"

# Generate a csv file with the given row data.
# Note: row_data should be an array of arrays where each inner array is a single row
def generate_csv_file(file_path, row_data)
  CSV.open(file_path, "wb") do |csv|
    csv << ["first_name", "last_name", "dob", "member_id", "effective_date", "expiry_date", "phone_number"]
    row_data.each { |row| csv << row }
  end
end

# Get a file path relative to the test/data directory
def get_data_file_path(file_name)
  File.expand_path("../data/#{file_name}", __FILE__)
end
