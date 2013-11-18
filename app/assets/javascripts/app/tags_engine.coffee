angular
  .module('twoyears.tags',[])
  .factory('Tag', 
    ($resource) ->
      class Tag
        constructor: () ->

        all: () ->
          $resource('/api/tags.json').query()
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