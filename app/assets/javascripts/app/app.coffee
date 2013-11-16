angular
	.module('twoyears', ['ngRoute', 'ngResource', 'twoyears.controllers', 'twoyears.services'])
  .config(
    ($routeProvider) ->
      $routeProvider.when('/', {
        templateUrl: '/commits'
      }).otherwise({redirectTo: '/'})
  )