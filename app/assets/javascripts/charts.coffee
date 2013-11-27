class @RickshawChart
  constructor: (@baseSelector, withLegend) ->
    withLegend = false unless withLegend
    $(@baseSelector).html(@resetHTML())
    @palette = new Rickshaw.Color.Palette( { scheme: 'munin' } );

  resetHTML: () ->
    "<div class='chart'></div><div class='x-axis'></div><div id='slider'></div><div class='legend'></div>"

  yaxis: (graph) ->
    yAxis = new Rickshaw.Graph.Axis.Y({ graph: graph });

    yAxis.render();

  labeling: (graph, shelving) ->
    legend = new Rickshaw.Graph.Legend({
      graph: graph,
      element: document.querySelector("#{@baseSelector} .legend"),
      naturalOrder: true
    });

    highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
      graph: graph,
      legend: legend
    });

    if shelving
      shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
        graph: graph,
        legend: legend
      });

class @TagCountByDayChart extends RickshawChart
  constructor: (@baseSelector) ->
    super @baseSelector

    graph = new Rickshaw.Graph.Ajax({
      element: document.querySelector(".chart"),
      renderer: 'line',
      dataURL: '/api/commits/counts_by_day_as_rickshaw.json',
      onData: (data) =>
        # [{name: tag, color: #whatever, data: [positional counts] }]
        data.series.forEach(
          (series) =>
            newdata = []
            series.data.forEach (count, index) ->
              time = data.first_day + index * 86400
              newdata.push { x: time, y: count }
            series.data = newdata
            series.color = @palette.color();
        )
        data.series
      onComplete: (transport) =>
        graph = transport.graph;

        xAxis = new Rickshaw.Graph.Axis.Time({
          graph: graph,
          element: document.querySelector(".xaxis")
        });

        xAxis.render();

        hoverDetail = new Rickshaw.Graph.HoverDetail({
          graph: graph,
          xFormatter: (x) ->
            date = new Date(x*1000)
            date.getMonth() + "-" + date.getDate() + "-" + date.getFullYear()
          formatter: (series, x, y) ->
            series.name + ": " + (y|0) # Convert y to an integer
        });

        @yaxis(graph);

        @labeling(graph, true);

        slider = new Rickshaw.Graph.RangeSlider({
          graph: graph,
          element: $('#slider')
        });
    })

class @TotalsChart extends RickshawChart
  constructor: (@baseSelector, period) ->
    super @baseSelector

    graph = new Rickshaw.Graph.Ajax({
      element: document.querySelector(".chart"),
      renderer: 'line',
      dataURL: "/api/commits/by_period.json?period=#{period}",
      onData: (data) =>
        # [{first_day: 192318722, data: [positional counts]}]
        newseries = {}
        newseries.name = 'Commits'
        newseries.color = '#336699'
        newseries.data = []
        data.data.forEach (count, index) =>
          interval = index * 86400 # 24 hours * 60 minutes * 60 seconds
          interval *= 7 if period == "week"
          time = data.first_day + interval
          newseries.data.push { x: time, y: count }
        [newseries]

      onComplete: (transport) =>
        graph = transport.graph;

        xAxis = new Rickshaw.Graph.Axis.Time({
          graph: graph,
          element: document.querySelector(".xaxis")
        });

        xAxis.render();

        @yaxis(graph);

        hoverDetail = new Rickshaw.Graph.HoverDetail({
          graph: graph,
          xFormatter: (x) ->
            date = new Date(x*1000)
            date.getMonth()+1 + "-" + date.getDate() + "-" + date.getFullYear()
          formatter: (series, x, y) ->
            (y|0) # Convert y to an integer
        });

        slider = new Rickshaw.Graph.RangeSlider({
          graph: graph,
          element: $('#slider')
        });
    })

  resetHTML: () ->
    "<div class='chart'></div><div class='x-axis'></div><div id='slider'></div>"

class @TagByDayOfWeekChart extends RickshawChart
  constructor: (@baseSelector, text) ->
    super @baseSelector

    graph = new Rickshaw.Graph.Ajax({
      element: document.querySelector(".chart"),
      renderer: 'bar',
      dataURL: "/api/tags/#{text}/by_day_of_week.json",
      onData: (data) =>
        # [{data: [Sunday count,Monday count,...]}]
        newseries = {}
        newseries.data = []
        newseries.name = 'Commits'
        data.data.forEach (count, index) =>
          newseries.data.push { x: index, y: count }
        newseries.color = '#336699'
        [newseries]

      onComplete: (transport) =>
        graph = transport.graph

        xAxis = new Rickshaw.Graph.Axis.X({
          graph: graph,
          orientation: 'bottom',
          element: document.querySelector('.x-axis'),
          height: 20,
          tickFormat: (n) =>
            ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", ""][n]
          })

        xAxis.render()

        @yaxis(graph);
    });