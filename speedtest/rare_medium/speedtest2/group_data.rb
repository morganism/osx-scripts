#!/usr/bin/env ruby

require 'date'

# Convert dates and times to DateTime objects
date_times = dates.zip(times).map { |date, time| DateTime.strptime("#{date} #{time}", '%y%m%d %H%M%S') }

# Choose the time unit: 'day', 'week', or 'month'
time_unit = 'day'  # Replace with user preference

# Group data based on the selected time unit
grouped_data = date_times.group_by { |dt| dt.send(time_unit) }

# Aggregate download and upload values for each group
aggregated_data = grouped_data.transform_values do |date_times|
  {
    'Download' => downloads.values_at(*date_times.map.with_index { |_dt, i| i }),
    'Upload' => uploads.values_at(*date_times.map.with_index { |_dt, i| i })
  }
end

# Display the organized data
puts "Aggregated Data: #{aggregated_data}"

