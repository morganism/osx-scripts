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
          ['<%= row['DATETIME'] %>', <%= row['DOWNLOADLOW'] %>, <%= row['DOWNLOADHI'] %>, <%= row['UPLOAD'] %>],
        <% end %>
      ]);

// ...

var options = {
  title: 'Speedtest Data',
  curveType: 'none',
  legend: { position: 'bottom' },
  series: { //Create 2 separate series to fake what you want. One for the line             and one for the points
      0: {
          color: 'red',
          lineWidth: 1,
          pointSize: 2
      },
      1: {
          color: 'green',
          lineWidth: 1,
          pointSize: 2
      },
      2: {
          color: 'blue',
          lineWidth: 1,
          pointSize: 2
      }
  }
};


// Loop through each row to set colors based on DOWNLOAD values
for (var i = 0; i < data.getNumberOfRows(); i++) {
  var downloadValue = data.getValue(i, 1);
  var downloadValueHi = 0
  var downloadValueLow = 0
  if (downloadValue > 268) {
    downloadValueHi = downloadValue
  } else {
    downloadValueLow = downloadValue
  }
    
  var uploadValue = data.getValue(i, 2);

  // Set colors based on the condition for DOWNLOAD and UPLOAD
  var downloadColor = downloadValue > 268 ? '#00FF00' : '#FF0000';  // Adjusted this line
  var uploadColor = '#0000FF';

  // Set the color for the data points directly
  data.setValue(i, 1, downloadValueLow, downloadColor);
  data.setValue(i, 2, downloadValueHi, downloadColor);
  data.setValue(i, 3, uploadValue, uploadColor);
}

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

