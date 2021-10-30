# CsvProcessor

CSV Processor is a program that transforms raw CSV data in to a standardized format.

* Extra whitespace is trimmed for all fields
* Date fields are converted to ISO8601 format
* Phone numbers are converted to E.164 format

## Usage

```shell
bin/csv_processor [input_path] [output_path] [report_path]
```

* Arguments are assigned in order, and the following defaults are used if arguments are omitted:
  * input_path: `data/input.csv`
  * output_path: `data/output.csv`
  * report_path: `data/report.txt`



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.
