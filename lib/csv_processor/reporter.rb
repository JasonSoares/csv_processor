# frozen_string_literal: true

class Reporter
  attr_reader :success_count, :error_count, :row_issues

  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
    @success_count = @error_count = 0
    @row_issues = Hash.new
  end

  def report_success(row_number, comment)
    @success_count += 1
    @row_issues[row_number] = ok_status(comment) unless comment.empty?
  end

  def report_error(row_number, comment)
    @error_count += 1
    @row_issues[row_number] = error_status(comment)
  end

  def finalize(file_name)
    reporting_to(file_name) do |report|
      add_header report, "CSV Processor"

      add_section report, "Files"
      add_line report, "Input: #{@input_file}"
      add_line report, "Output: #{@output_file}"

      add_section report, "Statistics"
      add_line report, "Success count: #{@success_count}"
      add_line report, "Error count: #{@error_count}"

      add_section report, "Row details"
      add_row_issues report

      add_line report, "#{header_line}"
    end
  end

  private

  def reporting_to(file_name, &block)
    File.open(file_name, "w") do |file|
      yield file if block_given?
    end
  end

  def add_header(report, header_text)
    report.puts "#{header_line}"
    report.puts "#{header_text}"
    report.puts "#{header_line}"
  end

  def add_section(report, header_text)
    report.puts "#{section_line}"
    report.puts "#{header_text}"
    report.puts "#{section_line}"
  end

  def add_line(report, text)
    report.puts text
  end

  def add_row_issues(report)
    @row_issues.keys.sort.each do |key|
      row_issue = @row_issues[key]
      emoji = row_issue[:status] === :ok ? "✅" : "❌"
      add_line report, "#{emoji} [#{key}]: #{row_issue[:comment]}"
    end
  end

  def header_line
    "-" * 80
  end

  def section_line
    "-" * 40
  end

  def ok_status(comment)
    { status: :ok, comment: comment }
  end

  def error_status(comment)
    { status: :error, comment: comment }
  end
end
