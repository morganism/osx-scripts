# Required gems
require 'sinatra'
require 'json'

require_relative 'parser' # Update the path accordingly

CONFIG_FILE='.speedtest_plotter.json'
JSON_DATA='/Users/morgan/data/log/speedtest/speedtest.simple.log'


module RareMedium
  module SpeedTest
    class ChartApp < Sinatra::Base


      configure do
        set :config, JSON.parse(File.read(CONFIG_FILE), symbolize_names: true)
        disable :protection # Disable all protection middleware for testing
        enable :sessions
        set :bind, '0.0.0.0'
        set :port, 4567
      end

      get '/' do
puts 'hello'
        parser = Parser.new('.speedtest_plotter.json')
        parsed_data = parser.parse_log_file
pp parsed_data
        config = { source_path: JSON_DATA, guaranteed_download: 268, guaranteed_upload: 25 }
        erb :chart, locals: { data: parsed_data, config: config }
      end

    end
  end
end

# Run the app if executed directly
RareMedium::SpeedTest::ChartApp.run! if __FILE__ == $0
