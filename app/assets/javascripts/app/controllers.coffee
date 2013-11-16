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
      $scope.loadRickshaw = () ->
        graph = new Rickshaw.Graph.Ajax({
          element: document.querySelector("#chart"),
          renderer: 'line',
          dataURL: '/api/commits/counts_by_day_as_rickshaw.json',
          onData: (data) ->
            # [{name: tag, color: #whatever, data: [positional counts] }]
            data.forEach(
              (series) ->
                newdata = []
                series.data.forEach (count, index) ->
                  time = 1329807600 + index * 86400
                  newdata.push { x: time, y: count }
                series.data = newdata
            )
            data
          onComplete: (transport) ->
            graph = transport.graph;

            xAxis = new Rickshaw.Graph.Axis.Time({
              graph: graph,
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

      $timeout($scope.loadRickshaw, 0)
  );


