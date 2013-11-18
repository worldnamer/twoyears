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
      $scope.make_active = (toActivate) ->
        $("#charts .active").removeClass("active")
        $(toActivate).addClass("active")

      $scope.totals = () ->
        unless $("#totals").hasClass("active")
          $scope.make_active("#totals")

          chart = new TotalsChart('#chart-container')

      $scope.tag_count = () ->
        unless $("#by-tag").hasClass("active")
          $scope.make_active("#by-tag")

          chart = new TagCountChart('#chart-container')

      $scope.tag_count_by_day = () ->
        unless $("#by-day").hasClass("active")
          $scope.make_active("#by-day")

          chart = new TagCountByDayChart('#chart-container')

      $timeout($scope.totals, 0)
  )
  .controller("TagsController",
    ($scope, $timeout, Tag) ->
      $scope.showTag = (tag) ->
        $scope.$parent.shownTag = tag

        chart = new TagByDayOfWeekChart('#chart-container', tag.text)

      $scope.reloadTags = () ->
        tags = (new Tag).all()

        tags.$promise.then(() ->
          palette = new Rickshaw.Color.Palette( { scheme: 'munin' } );
          for tag in tags
            tag.color = palette.color()
        )

        $scope.tags = tags

      $timeout($scope.reloadTags, 0)
  );