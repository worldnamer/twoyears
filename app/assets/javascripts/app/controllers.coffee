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
    ($scope, $timeout) ->
      $scope.tag_count = () ->
        unless $("#overall").hasClass("active")
          $("#tags .active").removeClass("active")
          $("#overall").addClass("active")

          chart = new TagCountChart('#chart-container')

      $scope.tag_count_by_day = () ->
        unless $("#by-day").hasClass("active")
          $("#tags .active").removeClass("active")
          $("#by-day").addClass("active")

          chart = new TagCountByDayChart('#chart-container')

      $timeout($scope.tag_count_by_day, 0)
  );


