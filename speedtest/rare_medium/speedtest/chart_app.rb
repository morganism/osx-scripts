# Required gems
require 'sinatra'
require 'json'

require_relative 'parser'

JSON_DATA='/Users/morgan/data/log/speedtest/speedtest.json.log'

module RareMedium
  module SpeedTest
    class ChartApp < Sinatra::Base

      configure do
        set :config, JSON.parse(File.read(File.join(File.dirname(__FILE__), '.speedtest_plotter.json')), symbolize_names: true)
        disable :protection # Disable all protection middleware for testing
        enable :sessions
        set :bind, '0.0.0.0'
        set :port, 4567
      end

      get '/' do
        puts 'hello'
        parser = RareMedium::SpeedTest::Parser.new('.speedtest_plotter.json') # Update the file path accordingly
        parsed_data = parser.parse_log_file
        config = { source_path: JSON_DATA, guaranteed_download: 268, guaranteed_upload: 25 }
        erb :chart, locals: { data: parsed_data, config: config }
      end

    end
  end
end

# Run the app if executed directly
RareMedium::SpeedTest::ChartApp.run! if __FILE__ == $0

