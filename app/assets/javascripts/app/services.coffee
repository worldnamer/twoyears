angular.module('twoyears.services',[])
.factory('Commit', 
  ($resource) ->
    class Commit
      constructor: () ->
        @service = $resource('/api/commits.json')

      all: () ->
        @service.query()
);