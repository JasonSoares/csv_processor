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
    format = get_date_format(normalized_value)
    parse_with_format(normalized_value, format)
  end

  private_class_method def self.parse_with_format(date_string, format)
    date_string && Date.strptime(date_string, format)
  rescue Date::Error # parsed string, but date is not valid (e.g. 2021-10-32)
    nil
  end

  private_class_method def self.convert_to_iso_format(parsed_date)
    parsed_date && parsed_date.iso8601
  end

  private_class_method def self.get_date_format(normalized_value)
    case normalized_value
    when /^\d{1,2}-\d{1,2}-\d{2}$/
      "%m-%d-%y"
    when /^\d{1,2}-\d{1,2}-\d{4}$/
      "%m-%d-%Y"
    when /^\d{4}-\d{1,2}-\d{1,2}$/
      "%Y-%m-%d"
    else
      "" # results in date error, which results in nil
    end
  end
end
