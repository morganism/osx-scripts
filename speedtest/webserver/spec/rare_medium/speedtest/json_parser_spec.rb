# spec/rare_medium/speedtest/json_parser_spec.rb

require 'spec_helper'
require '.././../rare_medium/speedtest'

RSpec.describe RareMedium::Speedtest::JSONParser do
  describe '.parse' do
    it 'parses JSON data from the logfile' do
      logfile_path = 'path/to/your/logfile.json.log'
      json_data = '{"download": 13456892.93209621, "upload": 20480677.70426724, "ping": 22.731, "server": {"url": "http://riley.as48070.net:8080/speedtest/upload.php", "lat": "52.5695", "lon": "-0.2405", "name": "Peterborough", "country": "United Kingdom", "cc": "GB", "sponsor": "DSM Group", "id": "52523", "host": "riley.as48070.net:8080", "d": 122.10231405999286, "latency": 22.731}, "timestamp": "2023-12-23T09:28:39.263538Z", "bytes_sent": 25624576, "bytes_received": 16917056, "share": null, "client": {"ip": "82.0.169.84", "lat": "51.4805", "lon": "-0.0113", "isp": "Virgin Media", "isprating": "3.7", "rating": "0", "ispdlavg": "0", "ispulavg": "0", "loggedin": "0", "country": "GB"}}'

      parsed_data = RareMedium::Speedtest::JSONParser.parse(logfile_path)

      expect(parsed_data).to be_a(Array)
      expect(parsed_data.size).to eq(1)
      expect(parsed_data.first).to include(
        'download' => a_kind_of(Float),
        'upload' => a_kind_of(Float),
        'ping' => a_kind_of(Float),
        'timestamp' => a_kind_of(String)
        # Add more expectations based on your JSON structure
      )
    end

    it 'handles invalid JSON gracefully' do
      # Your test logic here, perhaps by providing an invalid JSON string
    end
  end
end

