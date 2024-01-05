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
  <%= stylesheet_link_tag 'https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css' %>
</head>
<body>
  <h1>Speedtest Data Visualization</h1>
  <%= line_chart @data, xtitle: 'DATETIME', ytitle: 'Speeds', library: { colors: ['#FF0000', '#0000FF'], curve: false, pointSize: 5, legend: 'bottom' } %>
  <%= javascript_include_tag 'https://www.gstatic.com/charts/loader.js' %>
  <%= javascript_include_tag 'https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js' %>
  <%= chartkick_javascript %>
</body>
</html>

