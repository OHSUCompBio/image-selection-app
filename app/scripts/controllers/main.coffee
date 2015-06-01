'use strict'

###*
 # @ngdoc function
 # @name imageSelectorApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the imageSelectorApp
###
angular.module 'imageSelectorApp'
  .controller 'MainCtrl', ['$http', '$scope', '$location', '$q', 'galaxy/workflow', 'galaxy/dataset', ($http, $scope, $location, $q, Workflow, Dataset) ->

    # Name of the workflow to invoke.
    workflowName = 'Upload Images'

    # Pagination options.
    @imagesPerPage = 9
    @currentPage = 1
    @pageCount = => return Math.ceil(@images.length / @imagesPerPage)

    # Flip the boolean value in our selectedImages object for a given image ID.
    @toggleImage = (imageId) ->
      image = _.findWhere(@images, id: imageId)
      image.selected = !image.selected

    # Test if an image is selected.
    @isSelected = (imageId) ->
      _.findWhere(@images, id: imageId, selected: true)?

    # Load images from /images.json and attach them to the scope.
    $http.get('images.json')
      .success (response) =>
        @images = response.data

        @totalImages = @images.length

        # Whenever the current page or images per page changes, update the 
        # filtered images.
        $scope.$watch ($scope) =>
          @currentPage + @imagesPerPage
        , =>
          begin = (@currentPage-1) * @imagesPerPage
          end = begin + @imagesPerPage
          @filteredImages = @images.slice(begin, end)

      .error (data) =>
        console.log 'Unable to fetch images.json'

    # Submit the selected images to the workflow specified by "workflowName"
    @submitWorkflow = =>

      # Extract out the dataset ID from the absulte url.
      datasetId = ($location.absUrl().match(/datasets\/([^\/]+)/) || [])[1] || '448837ac379d5c9e'

      workflowPromise = Workflow.getList().then (workflows) ->
        _.findWhere(workflows, name: workflowName)

      datasetPromise = Dataset.one(datasetId).get()

      $q.all([workflowPromise, datasetPromise]).then (data) =>
        [workflow, dataset] = data

        # Extract out imageIds whose values in @selectedImages are true.
        ids = _.chain(@images)
          .where(selected: true)
          .pluck('id')
          .value()
          .join(' ')

        payload = 
          history: "hist_id=#{dataset.history_id}"
          workflow: workflow.id
          parameters:
            ids: ids

        workflow.invoke(payload).then (response) =>
          @newWorkflow = response
          
    return

  ]
