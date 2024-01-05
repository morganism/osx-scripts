#!/usr/bin/env ruby
#
#
#
#
#
#
#
# Required gems
require 'colorize'
require 'json'
require 'speedtest'

# Module definition
module ST
  class String
    def colorize(color, options = {})
      # ... (your provided implementation)
    end
  end

  class Runner
    def initialize(options = {})
      # Initialize code here
    end

    def test(options = {})
      test = Speedtest::Test.new(
        download_runs: 4,
        upload_runs: 4,
        ping_runs: 4,
        download_sizes: [750, 1500],
        upload_sizes: [10000, 400000],
        debug: true
      )
      @results = test.run
    end

    def log_results
      # Convert @results to JSON and write to disk
      File.write('speedtest_results.json', @results.to_json)
    end
  end
end

