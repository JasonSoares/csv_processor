# frozen_string_literal: true

require "test_helper"
require "csv_processor/date_processor"

class DateProcessorTest < Minitest::Test
  def test_valid_date_strings_are_converted
    assert_equal("2021-01-01", DateProcessor.call("1/1/21"))
    assert_equal("2021-01-02", DateProcessor.call("1-2-21"))
    assert_equal("2021-01-03", DateProcessor.call("2021-1-3"))
  end

  def test_valid_date_strings_wtih_invalid_dates_return_nil
    assert_nil(DateProcessor.call("2021-02-29"))
    assert_nil(DateProcessor.call("2021-01-32"))
    assert_nil(DateProcessor.call("2021-1"))
  end

  def test_invalid_date_strings_return_nil
    assert_nil(DateProcessor.call("not-a-date"))
  end
end
