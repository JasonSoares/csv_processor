# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/csv_processor/text_processor"

class TextProcessorTest < Minitest::Test
  def test_blanks_are_stripped_from_sides
    assert_equal("Mary", TextProcessor.call("\tMary "))
    assert_equal("Mary Poppins", TextProcessor.call(" Mary Poppins\t"))
  end

  def test_blank_strings_return_nil
    assert_nil TextProcessor.call("")
    assert_nil TextProcessor.call(" ")
    assert_nil TextProcessor.call("\t")
  end
end
