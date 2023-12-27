#!/usr/bin/env ruby

# json_parser.rb

# Step 1: Require the 'json' library
require 'json'

# Step 2: Accept the JSON file name as a command-line argument
json_file = ARGV[0]

# Check if a file name is provided
if json_file.nil?
  puts "Please provide the JSON file name as an argument."
  exit
end
# Step 3: Read the JSON file using the provided file name
begin
  json_data = File.read(json_file)
rescue StandardError => e
  puts "Error reading the JSON file: #{e.message}"
  exit
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
#puts parsed_data.class

# End of script

