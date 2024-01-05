#!/usr/bin/env ruby

log_file_path = '~/data/log/speedtest/speedtest.simple.log'

# Read the log file
log_data = File.read(File.expand_path(log_file_path))

# Split the log entries
entries = log_data.split('---')

# Initialize arrays to store extracted data
dates = []
times = []
downloads = []
uploads = []

# Loop through each entry and extract data
entries.each do |entry|
  date_match = entry.match(/DATE: (\d{2}\/\d{2}\/\d{2}) TIME:(\d{2}:\d{2}:\d{2})/)
  download_match = entry.match(/Download: (\d+\.\d+) Mbit\/s/)
  upload_match = entry.match(/Upload: (\d+\.\d+) Mbit\/s/)

  if date_match && download_match && upload_match
    # Extracted data
    date = date_match[1].gsub('/', '')
    time = date_match[2].gsub(':', '')
    download = download_match[1].to_f
    upload = upload_match[1].to_f

    # Store in arrays
    dates << date
    times << time
    downloads << download
    uploads << upload
  end
end

# Display the extracted data
puts "Dates: #{dates}"
puts "Times: #{times}"
puts "Downloads: #{downloads}"
puts "Uploads: #{uploads}"

