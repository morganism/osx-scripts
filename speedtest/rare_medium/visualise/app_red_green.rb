# app.rb
require 'sinatra'
require 'csv'
require 'chartkick'

set :bind, '0.0.0.0'
set :port, 4567


get '/' do
  readCSV
  aggregate_stats
  erb :chart
end

def readCSV
  @data = CSV.read(File.expand_path('~/data/log/speedtest/speedtest.csv'), headers: true)
end

def aggregate_stats
  @total_point_count = 0
  @download_lo_count = 0
  @download_hi_count = 0

  strks = []

  @data.each do |row|
    datetime = row['DATETIME']
    download_lo = row['DOWNLOADLOW']
    download_hi = row['DOWNLOADHI']
    upload = row['UPLOAD']
    sla_value = row['SLA']

    sla = download_hi.to_i > 0 ? true : false # download Mbits/s is greater than SLA then 'sla' is true as it has been met
   
    @download_lo_count += 1 unless sla
    @download_hi_count += 1 if sla

    if (sla)
      strks << 1
    else
      strks << 0
    end

    @total_point_count += 1
  end
  @percent_sla = @download_hi_count.to_f / @total_point_count.to_f
  
  strks_string = strks.join('')
  strks_string.gsub!(/0+/, '0')
  @strks_ary = strks_string.split('0').sort.reverse
  @streak_count = {}
  @strks_ary.each do |elt|
    if (elt.length > 1) # a streak is more than 1 in a row
      key = "#{elt.length * 5}m"
      @streak_count[key] = (@streak_count[key].nil?) ? 1 : @streak_count[key] + 1
    end
  end
  
 
  
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
      data.addColumn('number', 'SLA');
      data.addRows([
        <% @data.each do |row| %>
          ['<%= row['DATETIME'] %>', <%= row['DOWNLOADLOW'] %>,<%= row['DOWNLOADHI'] %> ,<%= row['UPLOAD'] %>, <%= row['SLA'] %>],
        <% end %>
      ]);

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
                  2: { color: '#0000ff' },
                  3: { color: '#777777' }
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
  </script>

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
    .description {
      margin-top: 50px;
      margin-bottom: 50px;
    }
  </style>
</head>
<body>
  <main>
    <h1>Speedtest Data Visualization</h1>
    <div class="description" id="chart_div" style="height: 500px; width: 95%"></div>
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
    <div>
     <span>
      <ul>
        <li>Total point count = <%= @total_point_count %></li>
        <li>Below SLA count   = <%= @download_lo_count %></li>
        <li>Above SLA count   = <%= @download_hi_count %></li>
        <li>Percent SLA       = <%= @percent_sla %></li>
        <li>Streaks       = <%= @streak_count %></li>
      </ul>
      </span>
    </div>
  </main>
  <footer>
  <div>
    Copyleft. All rights reversed. <a target="_blank" href="https://git.morganism.dev/osx-utils/tree/master/speedtest/rare_medium/visualise/">GitHub source</a>
  </div>
  </footer>
</body>
</html>

