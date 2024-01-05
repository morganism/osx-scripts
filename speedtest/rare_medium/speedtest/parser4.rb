# Required gems
require 'date'
require 'json'

module RareMedium
  module SpeedTest
    class Parser
      attr_reader :config

      # Initialize with config file path
      def initialize(config_file_path)
        @config = load_config(config_file_path)
      end

      # Function to load configuration from file
      def load_config(file_path)
        JSON.parse(File.read(file_path), symbolize_names: true)
      rescue StandardError => e
        puts "Error loading config file: #{e.message}"
        {}
      end

      # Function to parse log file
      def parse_log_file
        data = []
        entry = {}  # Initialize entry hash

        File.readlines(@config[:source_path]).each do |line|
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

