'use strict'

###*
 # @ngdoc service
 # @name imageSelectorApp.galaxy/workflow
 # @description
 # # galaxy/workflow
 # Factory in the imageSelectorApp.
###
angular.module 'imageSelectorApp'
  .factory 'galaxy/workflow', ['galaxy', 'Restangular', (Galaxy, Restangular) ->

    Galaxy.extendModel('workflows', (workflow) ->
      workflow.invocations = Galaxy.service('invocations', workflow)

      workflow.invoke = (payload) ->
        workflow.invocations.post(payload)

      workflow
    )

    Galaxy.service('workflows')
  ]
