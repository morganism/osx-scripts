# Required gems
require 'date'
require 'json'

module RareMedium
  module SpeedTest
    class Parser
      attr_reader :file_path

      # Initialize with file path
      def initialize(file_path)
        @file_path = file_path
      end

      # Function to parse log file
      def parse_log_file
        data = []

        File.readlines(file_path).each do |line|
          if line.include?('DATE') && line.include?('TIME')
            entry = {}
            entry[:date] = DateTime.strptime(line.match(/DATE: (.*?) TIME:/)[1], '%m/%d/%y')
          elsif line.include?('Ping') || line.include?('Download') || line.include?('Upload')
            key, value = line.split(':').map(&:strip)
            entry[key.downcase.to_sym] = value.to_f
          elsif line.strip.empty? && !entry.empty?
            data << entry
            entry = {}
          end
        end

        data
      end
    end
  end
end

# Sample usage
log_file_path = '/Users/morgan/data/log/speedtest/speedtest.simple.log'
parser = RareMedium::SpeedTest::Parser.new(log_file_path)
parsed_data = parser.parse_log_file
puts JSON.pretty_generate(parsed_data)
