'use strict'

###*
 # @ngdoc service
 # @name imageSelectorApp.galaxy/history
 # @description
 # # galaxy/history
 # Factory in the imageSelectorApp.
###
angular.module 'imageSelectorApp'
  .factory 'galaxy/history', ['galaxy', 'Restangular', (Galaxy, Restangular) ->
    Galaxy.service('histories')
  ]
