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
      data.addColumn('number', 'DOWNLOADLOW');
      data.addColumn('number', 'DOWNLOADHI');
      data.addColumn('number', 'UPLOAD');
      data.addRows([
        <% @data.each do |row| %>
          ['<%= row['DATETIME'] %>', <%= row['DOWNLOADLOW'] %>,<%= row['DOWNLOADHI'] %> ,<%= row['UPLOAD'] %>],
        <% end %>
      ]);

// ...

var options = {
  title: 'Speedtest Data',
  curveType: 'none',
  legend: { position: 'bottom' },
  pointSize: 1,
  series: {
            0: { color: '#ff0000',
                 lineWidth: 2,
                 pointSize: 2 },
            1: { color: '#0fff0f',
                 lineWidth: 1,
                 pointSize: 2 },
            2: { color: '#0000ff' }
  }
};

// Loop through each row to set colors based on DOWNLOAD values
for (var i = 0; i < data.getNumberOfRows(); i++) {
  var downloadValue = data.getValue(i, 1);
  var uploadValue = data.getValue(i, 2);

  // Set colors based on the condition for DOWNLOAD and UPLOAD
  var downloadColor = downloadValue > 268 ? '#00FF00' : '#FF0000';  // Adjusted this line
  var uploadColor = uploadValue > 268 ? '#FF0000' : '#FF0000';

  // Set the color for the data points
  data.setRowProperty(i, 'style', 'point { stroke-color: ' + downloadColor + '; fill-color: ' + downloadColor + '; }');
  data.setRowProperty(i, 'style', 'point { stroke-color: ' + downloadColor + '; fill-color: ' + downloadColor + '; }');
  data.setRowProperty(i, 'style', 'point { stroke-color: ' + uploadColor + '; fill-color: ' + uploadColor + '; }');
}

var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
chart.draw(data, options);


    }


// ...

// Calculate DOWNLOAD as DOWNLOADHI + DOWNLOADLOW
data.addColumn('number', 'DOWNLOAD');
data.addRows([
  <% @data.each do |row| %>
    ['<%= row['DATETIME'] %>', <%= row['DOWNLOADLOW'].to_f + row['DOWNLOADHI'].to_f %>, <%= row['UPLOAD'] %>],
  <% end %>
]);

// ...

// Loop through each row to set colors based on DOWNLOAD values
for (var i = 0; i < data.getNumberOfRows(); i++) {
  var downloadValue = data.getValue(i, 1);
  var uploadValue = data.getValue(i, 2);

  // Set colors based on the condition for DOWNLOAD and UPLOAD
  var downloadColor = downloadValue > 268 ? '#00FF00' : '#8B0000'; // Dark red
  var uploadColor = uploadValue > 268 ? '#FF0000' : '#FF0000';

  // Set the color for the data points
  data.setRowProperty(i, 'style', 'point { stroke-color: ' + downloadColor + '; fill-color: ' + downloadColor + '; }');
  data.setRowProperty(i, 'style', 'point { stroke-color: ' + uploadColor + '; fill-color: ' + uploadColor + '; }');
}

// ...
  </script>
</head>
<body>
  <h1>Speedtest Data Visualization</h1>
  <div id="chart_div" style="height: 500px;"></div>
</body>
</html>

