# frozen_string_literal: truet

require "csv"
require_relative "csv_processor/date_processor"
require_relative "csv_processor/phone_processor"
require_relative "csv_processor/text_processor"

class CsvProcessor
  attr_reader :input_file, :output_file, :headers, :required_fields, :reporter

  def initialize(input_file, output_file, reporter)
    @input_file = input_file
    @output_file = output_file
    @reporter = reporter
    @headers = ["first_name", "last_name", "dob", "member_id", "effective_date", "expiry_date", "phone_number"]
    @required_fields = ["first_name", "last_name", "dob", "member_id", "effective_date"]
    @converters = ->(value, field) {
      case field.header
      when "first_name", "last_name", "member_id"
        TextProcessor.call(value)
      when "dob", "effective_date", "expiry_date"
        DateProcessor.call(value)
      when "phone_number"
        PhoneProcessor.call(value)
      end
    }
  end

  def call
    with_output_file do |output|
      output << @headers

      read_rows do |row, row_number|
        is_valid, missing_columns = validate_row(row)
        output << row if is_valid
        report_success(row_number, missing_columns) if is_valid
        report_failure(row_number, missing_columns) unless is_valid
      end
    end
  end

  private

  def read_rows(&block)
    options = { headers: true, encoding: "bom|utf-8", converters: @converters }

    CSV.foreach(@input_file, **options).with_index(1) do |row, row_number|
      yield row, row_number if block_given?
    end
  end

  def with_output_file(&block)
    CSV.open(@output_file, "w") do |csv|
      yield csv if block_given?
    end
  end

  def validate_row(row)
    invalid_fields = @headers.select { |field| row[field].nil? }
    is_valid = @required_fields.all? { |field| !row[field].nil? }
    return is_valid, invalid_fields
  end

  def report_success(row_number, missing_columns)
    comment = get_comment(missing_columns)
    @reporter && @reporter.report_success(row_number, comment)
  end

  def report_failure(row_number, missing_columns)
    comment = get_comment(missing_columns)
    @reporter && @reporter.report_error(row_number, comment)
  end

  def get_comment(missing_columns)
    missing_columns && missing_columns.length > 0 ? "missing #{missing_columns.join(', ')}" : ""
  end
end
