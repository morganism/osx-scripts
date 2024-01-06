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
  fails_string = strks_string
  strks_string = strks_string.gsub(/0+/, '0')
  fails_string = fails_string.gsub(/1+/, '1')
  @strks_ary = strks_string.split('0').sort.reverse
  @fails_ary = fails_string.split('1').sort.reverse
  @streak_count = {}
  @fails_count = {}
  @strks_ary.each do |elt|
    if (elt.length > 2) # a streak is more than 2 in a row
      key = "#{elt.length * 5}m"
      @streak_count[key] = (@streak_count[key].nil?) ? 1 : @streak_count[key] + 1
    end
  end
  @fails_ary.each do |elt|
    if (elt.length > 2) # a streak is more than 2 in a row
      key = "#{elt.length * 5}m"
      @fails_count[key] = (@fails_count[key].nil?) ? 1 : @fails_count[key] + 1
    end
  end
  
  # let's use some beautiful ruby sugar to calculate days, hours, minutes of given duration in sconds
  # @total_point_count * 5 will give total_seconds
  total_seconds = @total_point_count * 5 * 60                                  # number of seconds  
  @time_span = Time.at(total_seconds).utc.strftime("%H:%M:%S")

  mm, ss = total_seconds.divmod(60)
  hh, mm = mm.divmod(60)
  dd, hh = hh.divmod(24)
  @sample_span_dhms = "%d days, %d hours, %d minutes and %d seconds" % [dd, hh, mm, ss]
 
  
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
    .td65percent {
      max-width: 300px; // Desired max width
      width: max-content;
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
    .metric_description {
      color: "#555555";
    }
    table{
      table-layout: fixed;
      border: 1px solid black;
      border-collapse: collapse;
    }
    td{
      word-wrap:break-word;
      max-width: 25%;
      border: 1px solid black;
      border-collapse: collapse;
    }
    th {
      border: 1px solid black;
      border-collapse: collapse;
      background-color: lightgrey;
    }
    tr:nth-child(even) {
      background-color: #f2f2f2;
      border: 1px solid black;
      border-collapse: collapse;
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
        <table>
          <tr>
            <th>Metric</th>
            <th>Value</th>
            <th>Description</th>
          </tr> 
  
          <tr>
            <td>Sample Span</td>
            <td class="td65percent"><%= @sample_span_dhms %></div></td>
            <td><span class="metric_description">The span of time covered by these metrics.</span></td>
          </tr> 
          <tr>
            <td>Total point count</td>
            <td class="td65percent"><%= @total_point_count %></div></td>
            <td><span class="metric_description">The total count of the 5 minute samples present in the metric calculations.</span></td>
          </tr> 
          <tr>
            <td>Below SLA count</td>
            <td><div class="td65percent"><%= @download_lo_count %></div></td>
            <td><span class="metric_description">The count of 5 minute samples that fall below the published SLA value of 268 Mbits/s</span></td>
          </tr> 
          <tr>
            <td>Above SLA count</td>
            <td></span><div class="td65percent"><%= @download_hi_count %></div></td>
            <td><span class="metric_description">The count of 5 minute samples that fall within the published 268 Mbit/s SLA.</span></td>
          </tr> 
          <tr>
            <td>Percent SLA</td>
            <td><div class="td65percent"><%= sprintf('%0.2f' '%%', @percent_sla.to_f*100) %></div></td>
            <td><span class="metric_description">The percentage of all 5 minute samples that meet the SLA criterion.</span></td>
          </tr> 
          <tr>
            <td>Within SLA Streaks</td> 
            <td><div class="td65percent"><%= @streak_count %></div></td>
            <td><span class="metric_description">Streaks that fall within the SLA. A 'Streak' is defined herein as 3 or more contiguous 5 minute samples. This value is a hash of Streak Length in minutes :: Count of the number of streaks of that duration.</span></td>
          </tr> 
          <tr>
            <td>Fail SLA Streaks</td>
            <td><div class="td65percent"><%= @fails_count %></div></td>
            <td><span class="metric_description">Streaks failing to meet the SLA. A 'Streak' is defined herein as 3 or more contiguous 5 minute samples. This value is a hash of Streak Length in minutes :: Count of the number of streaks of that duration.</span></td>
          </tr> 
        </table>
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

