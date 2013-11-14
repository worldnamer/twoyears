angular
  .module('twoyears.controllers',[])
  .controller('CommitsController', 
    ($scope, Commit) ->
      $scope.commits = new Commit().all();
  );