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
  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'DATETIME');
      data.addColumn('number', 'DOWNLOAD');
      data.addColumn('number', 'UPLOAD');
      data.addRows([
        <% @data.each do |row| %>
          ['<%= row['DATETIME'] %>', <%= row['DOWNLOAD'] %>, <%= row['UPLOAD'] %>],
        <% end %>
      ]);

      var options = {
        title: 'Speedtest Data',
        curveType: 'none',
        legend: { position: 'bottom' },
        colors: ['#FF0000', '#0000FF'],
        pointSize: 5
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    }
  </script>
</head>
<body>
  <h1>Speedtest Data Visualization</h1>
  <div id="chart_div" style="height: 500px;"></div>
</body>
</html>

