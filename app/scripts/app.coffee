'use strict'

###*
 # @ngdoc overview
 # @name imageSelectorAppApp
 # @description
 # # imageSelectorAppApp
 #
 # Main module of the application.
###
angular
  .module 'imageSelectorAppApp', [
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

