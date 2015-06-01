'use strict'

###*
 # @ngdoc factory
 # @name imageSelectorApp.galaxy
 # @description
 # # galaxy
 # Factory in the imageSelectorApp.
###
angular.module 'imageSelectorApp'
  .factory 'galaxy', ['Restangular', (Restangular) ->
    host = 'http://localhost:8080/api'

    Restangular.withConfig (restangularConfigurer) ->
      restangularConfigurer.setBaseUrl(host)
  ]
