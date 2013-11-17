class @RickshawChart
  constructor: (@baseSelector) ->
    $(@baseSelector).html("<div class='chart'></div><div class='x-axis'></div><div class='legend'></div>")
    @palette = new Rickshaw.Color.Palette( { scheme: 'munin' } );

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

class @TagCountChart extends RickshawChart
  constructor: (@baseSelector) ->
    super @baseSelector

    graph = new Rickshaw.Graph.Ajax({
      element: document.querySelector(".chart"),
      renderer: 'bar',
      dataURL: '/api/commits/tag_counts.json',
      onData: (data) =>
        @tags = []

        data.forEach((element) =>
          @tags.push(element)
          element.color = @palette.color();
        )
        data
      onComplete: (transport) =>
        graph = transport.graph;

        xAxis = new Rickshaw.Graph.Axis.X({
          graph: graph,
          orientation: 'bottom',
          element: document.querySelector('.x-axis'),
          height: 20,
          tickFormat: (n) =>
            if n < @tags.length
              @tags[n].name
            else
              ""
          })

        xAxis.render();

        @yaxis(graph);

        @labeling(graph);
    })

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

        @yaxis(graph);

        @labeling(graph, true);          
    })