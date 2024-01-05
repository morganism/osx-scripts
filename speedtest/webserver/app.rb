#!/usr/bin/env ruby
# app.rb

require 'sinatra'
require 'rare_medium/speedtest/chart_generator'

JSON_DATA='/Users/morgan/data/log/speedtest//speedtest.json.log'

get '/' do
  data = RareMedium::Speedtest::JSONParser.parse(JSON_DATA)
  chart_type = params[:chart_type] || 'bar'
  
  RareMedium::Speedtest::ChartGenerator.generate_chart(data, chart_type.to_sym)
end

