# spec/spec_helper.rb

require 'bundler/setup'
require 'rspec'

# Adjust the relative path based on your project structure
require_relative '../../rare_medium/speedtest/json_parser'
require_relative '../../rare_medium/speedtest/chart'
require_relative '../../rare_medium/speedtest/bar'
require_relative '../../rare_medium/speedtest/stacked_bar'
require_relative '../../rare_medium/speedtest/line'
require_relative '../../rare_medium/speedtest/scatter'
require_relative '../../rare_medium/speedtest/pie'
require_relative '../../rare_medium/speedtest/chart_generator'

RSpec.configure do |config|
  # Your RSpec configuration goes here
end
