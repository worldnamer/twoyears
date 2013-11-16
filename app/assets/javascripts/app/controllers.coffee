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
          renderer: 'bar',
          dataURL: '/api/commits/tag_counts.json',
          onData: (data) ->
            console.log(data)
            $scope.tags = []
            data.forEach((element) ->
              $scope.tags.push(element)
            )
            data
          onComplete: (transport) ->
            graph = transport.graph;

            legend = new Rickshaw.Graph.Legend({
              graph: graph,
              element: document.querySelector('#legend')
            });

            highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
              graph: graph,
              legend: legend
            });

            xAxis = new Rickshaw.Graph.Axis.X({
              graph: graph,
              orientation: 'bottom',
              tickFormat: (n) ->
                $scope.tags[n].name
            })

            yAxis = new Rickshaw.Graph.Axis.Y({
              graph: graph
            });

            yAxis.render();

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


