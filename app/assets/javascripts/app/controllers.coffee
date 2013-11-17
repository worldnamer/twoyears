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
  .controller("CommitsChartsController",
    ($scope, $timeout) ->
      $scope.totals = () ->
        unless $("#totals").hasClass("active")
          $("#charts .active").removeClass("active")
          $("#totals").addClass("active")

          chart = new TotalsChart('#chart-container')

      $scope.tag_count = () ->
        unless $("#by-tag").hasClass("active")
          $("#charts .active").removeClass("active")
          $("#by-tag").addClass("active")

          chart = new TagCountChart('#chart-container')

      $scope.tag_count_by_day = () ->
        unless $("#by-day").hasClass("active")
          $("#charts .active").removeClass("active")
          $("#by-day").addClass("active")

          chart = new TagCountByDayChart('#chart-container')

      $timeout($scope.totals, 0)
  );


