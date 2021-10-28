# frozen_string_literal: true

require "date"

class DateProcessor
  def self.call(value)
    normalized_value = normalize(value)
    parsed_value = parse(normalized_value)
    cleaned_value = convert_to_iso_format(parsed_value)
    cleaned_value
  rescue ArgumentError # un-parseable date string
    nil
  end

  private_class_method def self.normalize(value)
    value && value.gsub(/\//, "-").strip # convert '/' characters to '-'
  end

  private_class_method def self.parse(normalized_value)
    parse_with_format(normalized_value, "%m-%d-%y") ||
    parse_with_format(normalized_value, "%m-%d-%Y") ||
    parse_with_format(normalized_value, "%Y-%m-%d")
  end

  private_class_method def self.parse_with_format(date_string, format)
    Date.strptime(date_string, format)
  rescue Date::Error # parsed string, but date is not valid (e.g. 2021-10-32)
    nil
  end

  private_class_method def self.convert_to_iso_format(parsed_date)
    parsed_date && parsed_date.iso8601
  end
end
