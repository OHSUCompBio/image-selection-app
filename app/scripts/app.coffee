'use strict'

###*
 # @ngdoc overview
 # @name imageSelectorApp
 # @description
 # # imageSelectorApp
 #
 # Main module of the application.
###
angular
  .module 'imageSelectorApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.bootstrap',
    'restangular'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

