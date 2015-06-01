'use strict'

###*
 # @ngdoc service
 # @name imageSelectorApp.galaxy/dataset
 # @description
 # # galaxy/dataset
 # Factory in the imageSelectorApp.
###
angular.module 'imageSelectorApp'
  .factory 'galaxy/dataset', ['galaxy', 'Restangular', (Galaxy, Restangular) ->

    Restangular.extendModel('datasets', (dataset) ->
      dataset.history = ->
        Restangular.one('histories', dataset.history_id)

      dataset
    )

    Galaxy.service('datasets')
  ]
