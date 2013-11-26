angular
  .module('twoyears.commits', [])
  .factory('Commit', 
    ($resource) ->
      class Commit
        constructor: () ->

        all: () ->
          $resource('/api/commits.json').query()

        addTag: (commit, tag) ->
          commit.tags.push({text: tag})

          tag_for_uri = encodeURIComponent(tag)
          resource = $resource("/api/commits/#{commit.commit_hash}/tags/#{tag_for_uri}", {}, 
            update:
              method: 'PUT'
          )

          resource.update(
            text: tag
          )

        removeTag: (commit, index) ->
          commit.tags.forEach (tag, i) ->
            if i == index
              removed = commit.tags.splice(i, 1)
              $resource("/api/commits/#{commit.commit_hash}/tags/#{removed[0].text}").delete()
  )
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
      $scope.totals_showing = true
      $scope.period = "day"

      $scope.make_active = (toActivate) ->
        $("#charts .active").removeClass("active")
        $(toActivate).addClass("active")

      $scope.totals = (force) ->
        if (!$("#totals").hasClass("active") or force)
          $scope.make_active("#totals")

          chart = new TotalsChart('#chart-container', $scope.period)

          $(".period").removeClass("btn-info")
          $(".period.#{$scope.period}").addClass("btn-info")
          $scope.totals_showing = true

      $scope.rerender_totals = (period) ->
        $scope.period = period
        $scope.totals(true)

      $scope.tag_count_by_day = () ->
        unless $("#by-day").hasClass("active")
          $scope.make_active("#by-day")

          chart = new TagCountByDayChart('#chart-container')

          $scope.totals_showing = false

      $timeout($scope.totals, 0)
  )
