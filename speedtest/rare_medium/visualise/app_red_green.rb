# app.rb
require 'sinatra'
require 'csv'
require 'chartkick'

set :bind, '0.0.0.0'
set :port, 4567


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
  <link rel="stylesheet" type="text/css" href="styles.css">
  <style>
    .red
    {
      color:red;
    }
    .green
    {
      color:green;
    }
    .blue
    {
      color:blue;
    }
    body {
      margin: 10px;
    }
    
    main {
      min-height: calc(100vh - 4rem);
    }
    
    footer {
      height: 4rem;
      position: fixed;
      bottom: 0;
      margin-left: 10px;
      margin-right: 10px;
    }
    #chart_div_description {
      margin-top: 50px;
      margin-bottom: 50px;
    }
  </style>
</head>
<body>
  <main>
    <h1>Speedtest Data Visualization</h1>
    <div id="chart_div" style="height: 500px; width: 95%"></div>
    <div id="chart_div_description">
      <span id="chart_div_description_span">
        This chart shows Speedtest results of samples taken every 5 minute. The Y-axis or height of the point indicates the value for Mbits/s at the time the sample was measured.
      </span>
        <ul id="chart_div_description_span_ul">
          <li>DOWNLOADLOW is in <span class="red">RED</span>. Any sample that has a value which is less than the published SLA (268 Mbits/s) is part of this series.</li>
          <li>DOWNLOADHI is in <span class="green">GREEN</span>. Any sample that has a value which equals or exceeds the published SLA is part of this series.</li>
          <li>UPLOAD is in <span class="blue">BLUE</span>.</li>
        </ul>
    </div>
  <main>
  <footer>
  <div>
    Copyleft. All rights reversed. <a target="_blank" href="https://git.morganism.dev/osx-utils/tree/master/speedtest/rare_medium/visualise/">GitHub source</a>
  </div>
  </footer>
</body>
</html>

