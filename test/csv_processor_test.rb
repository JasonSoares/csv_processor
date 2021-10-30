# frozen_string_literal: true

require "test_helper"

class CsvProcessorTest < Minitest::Test
  def test_succesfully_processes_valid_rows
    # Arrange
    input_path = get_data_file_path("input_valid.csv") # File.expand_path("../data/#{input_file_name}", __FILE__)
    output_path = get_data_file_path("output_valid.csv") # File.expand_path("../data/#{output_file_name}", __FILE__)
    csv_processor = CsvProcessor.new(input_path, output_path, nil)
    generate_csv_file(input_path, [
      ["Brent ","Wilson","1/1/1988","349090","9/30/19","9/30/2000","(303) 887 3456"],
      ["Jerry","Jones","6/6/99","jkj3343","8/4/16","12/12/2050",], # missing phone, but ok
      ["Benny","Samson","1/13/88","349102","9/30/19","","44425559884"] # missing expiry_date, invalid phone_number, but ok
    ])

    # Act
    csv_processor.call

    # Assert
    rows = CSV.open(output_path).each.to_a
    assert_equal(["first_name", "last_name", "dob", "member_id", "effective_date", "expiry_date", "phone_number"], rows[0])
    assert_equal(["Brent","Wilson","1988-01-01","349090","2019-09-30","2000-09-30","+13038873456"], rows[1])
    assert_equal(["Jerry","Jones","1999-06-06", "jkj3343", "2016-08-04", "2050-12-12", nil], rows[2])
    assert_equal(["Benny","Samson","1988-01-13","349102","2019-09-30",nil,nil], rows[3])
  end

  def test_rejects_invalid_rows
    # Arrange
    input_path = get_data_file_path("input_invalid.csv")
    output_path = get_data_file_path("output_invalid.csv")
    csv_processor = CsvProcessor.new(input_path, output_path, nil)
    generate_csv_file(input_path, [
      ["Mary","Poppins","1/7/1988","uu 90990","9/30/19","12/16/50","444-555-9878"],
      ["Jason","Bateman ","12/12/2010","AB 0000","","",""] # missing effective_date, should be rejected
    ])

    # Act
    csv_processor.call

    # Assert
    rows = CSV.open(output_path).each.to_a
    assert_equal(2, rows.length)
    assert_equal(["first_name", "last_name", "dob", "member_id", "effective_date", "expiry_date", "phone_number"], rows[0])
    assert_equal(["Mary","Poppins","1988-01-07","uu 90990","2019-09-30","2050-12-16","+14445559878"], rows[1])
  end
end
