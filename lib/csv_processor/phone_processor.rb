# frozen_string_literal: true

class PhoneProcessor
  def self.call(value)
    normalized_value = normalize(value)
    parsed_value = parse(normalized_value)
    cleaned_value = convert_to_e164(parsed_value)
    cleaned_value
  end

  private_class_method def self.normalize(value)
    value && value.gsub(/[^0-9]/, "") # remove all non-numeric characters
  end

  private_class_method def self.parse(normalized_value)
    value_with_country_code = normalized_value && normalized_value[0] === "1" ? normalized_value : "1#{normalized_value}"
    value_with_country_code && value_with_country_code.length === 11 ? value_with_country_code : nil
  end

  private_class_method def self.convert_to_e164(parsed_value)
    parsed_value && "+#{parsed_value}"
  end
end
