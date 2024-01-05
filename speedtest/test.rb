#!/usr/bin/env ruby

require 'json'
require 'speedtest'

test = Speedtest::Test.new(
    download_runs: 1,
    upload_runs: 1,
    ping_runs: 0,
    download_sizes: [750, 1500],
    upload_sizes: [10000, 400000],
    #debug: true
 )
 #=> #<Speedtest::Test:0x007fac5ac9dca0 @download_runs=4, @upload_runs=4, @ping_runs=4, @download_sizes=[750, 1500], @upload_sizes=[10000, 400000], @debug=true>

results = test.run

puts '--------------'
puts results
puts '--------------'
puts results.methods
