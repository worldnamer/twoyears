angular
	.module('twoyears', ['ngRoute', 'ngResource', 'twoyears.commits', 'twoyears.tags'])
  .config(
    ($routeProvider) ->
      $routeProvider.when('/', {
        templateUrl: '/commits'
      })
      .when('/tags', {
        templateUrl: '/tags'
      })
      .otherwise({redirectTo: '/'})
  )