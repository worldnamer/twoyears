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
          palette = new Rickshaw.Color.Palette( { scheme: 'colorwheel' } );
          tagMax = 0
          for tag in tags
            tag.color = palette.color()
            tagMax = tag.count if tag.count > tagMax
          $scope.tagMax = tagMax
        )

        $scope.tags = tags

      $timeout($scope.reloadTags, 0)
  );