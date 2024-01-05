#!/usr/bin/env ruby 


require 'sinatra'
require 'json'
require 'date'

# Method to process data from the log file
def process_data(log_data)
  entries = log_data.split('---')

  dates = []
  times = []
  downloads = []
  uploads = []

  entries.each do |entry|
    date_match = entry.match(/DATE: (\d{2}\/\d{2}\/\d{2}) TIME:(\d{2}:\d{2}:\d{2})/)
    download_match = entry.match(/Download: (\d+\.\d+) Mbit\/s/)
    upload_match = entry.match(/Upload: (\d+\.\d+) Mbit\/s/)

    if date_match && download_match && upload_match
      date = date_match[1].gsub('/', '')
      time = date_match[2].gsub(':', '')
      download = download_match[1].to_f
      upload = upload_match[1].to_f

      dates << date
      times << time
      downloads << download
      uploads << upload
    end
  end

  #date_times = dates.zip(times).map { |date, time| puts "Date:#{date} Time:#{time}" ; DateTime.strptime("#{date} #{time}", '%m/%d/%y %H:%M:%S') }
  date_times = dates.zip(times).map { |date, time|  DateTime.strptime("#{date} #{time}", '%m%d%y %H%M%S') }


  time_unit = 'day'  # Replace with user preference

  grouped_data = date_times.group_by { |dt| dt.send(time_unit) }

  grouped_data.transform_values do |date_times|
    {
      'Download' => downloads.values_at(*date_times.map.with_index { |_dt, i| i }),
      'Upload' => uploads.values_at(*date_times.map.with_index { |_dt, i| i })
    }
  end
end

# Read the log file
log_file_path = '~/data/log/speedtest/speedtest.simple.log'
log_data = File.read(File.expand_path(log_file_path))

# Process the data
aggregated_data = process_data(log_data)

# Define Sinatra app
class SpeedTestApp < Sinatra::Base
  set :port, 4567  # Choose a suitable port

  get '/chart' do
    content_type :json
    aggregated_data.to_json
  end
end

# Run the Sinatra app
SpeedTestApp.run!

