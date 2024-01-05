#!/usr/bin/env ruby

require 'sinatra'
require 'json'

# Your existing code for data organization goes here

# Define Sinatra app
class SpeedTestApp < Sinatra::Base
  set :port, 4567  # Choose a suitable port

  get '/chart' do
    content_type :json

    # Respond with the aggregated data in JSON format
    aggregated_data.to_json
  end

  # Additional routes or configurations can be added as needed
end

# Run the Sinatra app
SpeedTestApp.run!

