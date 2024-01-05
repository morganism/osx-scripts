# app.rb
require 'sinatra'
require 'csv'
require 'chartkick'

get '/' do
  @data = CSV.read(File.expand_path('~/data/log/speedtest/speedtest.csv'), headers: true)
  erb :chart
end

__END__

@@ chart
<!DOCTYPE html>
<html>
<head>
  <%= chartkick_chart_html @data, xtitle: 'DATETIME', ytitle: 'Speeds', library: { colors: ['#FF0000', '#0000FF'], curve: false, pointSize: 5, legend: 'bottom' } %>
  <%= chartkick_chart_js %>
</head>
<body>
  <h1>Speedtest Data Visualization</h1>
</body>
</html>

