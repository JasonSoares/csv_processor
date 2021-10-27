# frozen_string_literal: true

class TextProcessor
  def self.call(value)
    cleaned_value = clean(value)
    cleaned_value
  end

  private_class_method def self.clean(value)
    if value.nil?
      nil
    else
      cleaned_value = value.strip
      cleaned_value == "" ? nil : cleaned_value
    end
  end
end
