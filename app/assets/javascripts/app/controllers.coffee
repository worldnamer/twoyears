angular
  .module('twoyears.controllers',[])
  .controller('CommitsController', 
    ($scope, $timeout, Commit) ->
      commit_resource = new Commit()

      $scope.reloadCommits = () ->
        $scope.commits = commit_resource.all()

      $scope.removeTag = (commit, index) ->
        commit_resource.removeTag(commit, index)

      $scope.addTag = (commit, tag) ->
        commit_resource.addTag(commit, tag)

      $scope.$on('addTag', (eventObject, commit, tag) ->
        $scope.addTag(commit, tag)
      )
    
      $scope.$on('removeTag', (eventObject, commit, index) ->
        $scope.removeTag(commit, index)
      )

      $timeout($scope.reloadCommits, 0)
  )
  .controller("TagsController",
    ($scope, $timeout, Tag) ->
      $scope.tag_count = () ->
        unless $("#overall").hasClass("active")
          $("#tags .active").removeClass("active")
          $("#overall").addClass("active")

          $("#chart-container").html("<div id='chart'></div><div id='x-axis'></div><div id='legend'></div>")

          graph = new Rickshaw.Graph.Ajax({
            element: document.querySelector("#chart"),
            renderer: 'bar',
            dataURL: '/api/commits/tag_counts.json',
            onData: (data) ->
              palette = new Rickshaw.Color.Palette( { scheme: 'munin' } );
              $scope.tags = []

              data.forEach((element) ->
                $scope.tags.push(element)
                element.color = palette.color();
              )
              data
            onComplete: (transport) ->
              graph = transport.graph;

              xAxis = new Rickshaw.Graph.Axis.X({
                graph: graph,
                orientation: 'bottom',
                element: document.querySelector('#x-axis'),
                height: 20,
                tickFormat: (n) ->
                  if n < $scope.tags.length
                    $scope.tags[n].name
                  else
                    console.log("tickFormat received for #{n} but there are only #{$scope.tags.length} elements.")
                    ""
                })

              xAxis.render();

              yAxis = new Rickshaw.Graph.Axis.Y({
                graph: graph
              });

              yAxis.render();

              legend = new Rickshaw.Graph.Legend({
                graph: graph,
                element: document.querySelector('#legend'),
                naturalOrder: true
              });

              highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
                graph: graph,
                legend: legend
              });
          })

      $scope.tag_count_by_day = () ->
        unless $("#by-day").hasClass("active")
          $("#tags .active").removeClass("active")
          $("#by-day").addClass("active")

          $("#chart-container").html("<div id='chart'></div><div id='x-axis'></div><div id='legend'></div>")

          graph = new Rickshaw.Graph.Ajax({
            element: document.querySelector("#chart"),
            renderer: 'line',
            dataURL: '/api/commits/counts_by_day_as_rickshaw.json',
            onData: (data) ->
              # [{name: tag, color: #whatever, data: [positional counts] }]
              palette = new Rickshaw.Color.Palette( { scheme: 'munin' } );

              data.forEach(
                (series) ->
                  newdata = []
                  series.data.forEach (count, index) ->
                    time = 1329807600 + index * 86400
                    newdata.push { x: time, y: count }
                  series.data = newdata
                  series.color = palette.color();
              )
              data
            onComplete: (transport) ->
              graph = transport.graph;

              xAxis = new Rickshaw.Graph.Axis.Time({
                graph: graph
              });

              xAxis.render();

              yAxis = new Rickshaw.Graph.Axis.Y({
                graph: graph
              });

              yAxis.render();

              legend = new Rickshaw.Graph.Legend({
                graph: graph,
                element: document.querySelector('#legend'),
                naturalOrder: true
              });

              shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
                graph: graph,
                legend: legend
              });

              highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
                graph: graph,
                legend: legend
              });

              # hoverDetail = new Rickshaw.Graph.HoverDetail( {
              #   graph: graph,
              #   formatter: (series, x, y) ->
              #     if y > 0
              #       return "#{series.name}: #{y}"
              #     else
              #       return null;

              #   xFormatter: (x) ->
              #     return ""
              # });            
          })

      $timeout($scope.tag_count_by_day, 0)
  );


