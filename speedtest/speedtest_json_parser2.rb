#!/usr/bin/env ruby
# json_parser.rb

# Step 1: Require the 'json' library
require 'json'

# Step 2: Accept the JSON file name or data as a command-line argument
json_source = ARGV[0]

# Step 3: If a file name is not provided, attempt to read from standard input
if json_source.nil?
  json_data = $stdin.read
else
  # If a file name is provided, read the JSON file
  begin
    json_data = File.read(json_source)
  rescue StandardError => e
    puts "Error reading the JSON file: #{e.message}"
    exit
  end
end

# Step 4: Parse the JSON data into Ruby hashes
begin
  parsed_data = JSON.parse(json_data)
rescue JSON::ParserError => e
  puts "Error parsing JSON: #{e.message}"
  exit
end

# Step 5: Utilize the resulting hashes in your code
# For now, let's just print the parsed data
puts parsed_data.class

# End of script

