#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'date'

# Define Sinatra app
class SpeedTestApp < Sinatra::Base



# Method to process data from the log file
def process_data(log_data)
  entries = log_data.split('---')

  dates = []
  times = []
  downloads = []
  uploads = []

  entries.each do |entry|
    date_match = entry.match(/DATE:(\d{2})(\d{2})(\d{2}) TIME:(\d{2})(\d{2})(\d{2})/)
    download_match = entry.match(/Download: (\d+\.\d+) Mbit\/s/)
    upload_match = entry.match(/Upload: (\d+\.\d+) Mbit\/s/)

    if date_match && download_match && upload_match
      date = date_match[1..3].join
      time = date_match[4..6].join
      download = download_match[1].to_f
      upload = upload_match[1].to_f

      dates << date
      times << time
      downloads << download
      uploads << upload
    end
  end

  date_times = dates.zip(times).map { |date, time| DateTime.strptime("#{date} #{time}", '%y%m%d %H%M%S') }

  time_unit = 'day'  # Replace with user preference

  grouped_data = date_times.group_by { |dt| dt.send(time_unit) }

  grouped_data.transform_values do |date_times|
    {
      'Download' => downloads.values_at(*date_times.map.with_index { |_dt, i| i }),
      'Upload' => uploads.values_at(*date_times.map.with_index { |_dt, i| i })
    }
  end
  grouped_data
end

  set :port, 4567  # Choose a suitable port

  get '/chart' do
    content_type :json

    # Read the log file
    log_file_path = '~/data/log/speedtest/speedtest.simple.log'
    log_data = File.read(File.expand_path(log_file_path))

    # Process the data within the Sinatra route
    aggregated_data = process_data(log_data)

    # Respond with the processed data in JSON format
    aggregated_data.to_json
  end

  get '/chart2' do
    content_type :json

    # Read the log file
    log_file_path = '~/data/log/speedtest/speedtest.simple.log'
    log_data = File.read(File.expand_path(log_file_path))

    # Process the data within the Sinatra route
    aggregated_data = process_data(log_data)

    # Print the processed data to the console for debugging
    puts "Processed Data: #{aggregated_data}"

    # Respond with the processed data in JSON format
    aggregated_data.to_json
  end
end

# Run the Sinatra app
SpeedTestApp.run!

