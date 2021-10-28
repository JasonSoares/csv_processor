# frozen_string_literal: true

require "test_helper"
require "csv_processor/phone_processor"

class PhoneProcessorTest < Minitest::Test
  def test_valid_numbers_are_converted
    expected = "+14445556789"
    assert_equal(expected, PhoneProcessor.call("(444) 555-6789"))
    assert_equal(expected, PhoneProcessor.call("444-555-6789"))
    assert_equal(expected, PhoneProcessor.call("444.555.6789"))
  end

  def test_invalid_numbers_return_nil
    assert_nil(PhoneProcessor.call("not-a-phone-number"))
    assert_nil(PhoneProcessor.call("123-456")) # too short
    assert_nil(PhoneProcessor.call("4444-555-6789")) # too long
  end
end
