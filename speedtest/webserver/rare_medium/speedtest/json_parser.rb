# rare_medium/speedtest/json_parser.rb

require 'json'

module RareMedium
  module Speedtest
    class JSONParser
      def self.parse(logfile_path = '~/data/log/speedtest/speedtest.json.log')
        json_data = File.read(File.expand_path(logfile_path))
        JSON.parse(json_data)
      rescue JSON::ParserError => e
        puts "Error parsing JSON: #{e.message}"
        []
      end
    end
  end
end

