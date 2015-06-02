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
        @errorMessage 'Unable to fetch images.json'

    # Submit the selected images to the workflow specified by "workflowName"
    @submitWorkflow = =>

      # Extract out the dataset ID from the absulte url.
      datasetId = ($location.absUrl().match(/datasets\/([^\/]+)/) || [])[1] || '448837ac379d5c9e'

      workflowPromise = Workflow.getList().then (workflows) ->

        # Note that we're querying throught the list of workflows the find the
        # one that matches the name we're looking for. We're calling `get()` on
        # that to send out another request to /workflows/:id to get the full
        # payload.
        _.findWhere(workflows, name: workflowName).get()

      datasetPromise = Dataset.one(datasetId).get()

      $q.all([workflowPromise, datasetPromise]).then (data) =>
        [workflow, dataset] = data

        # Extract out imageIds whose values in @selectedImages are true.
        file_ids = _.chain(@images)
          .where(selected: true)
          .pluck('id')
          .value()
          .join(' ')

        # We need to extract out the workflow step that has 'upload_images' as
        # the tool id.
        step = _.findWhere(workflow.steps, tool_id: 'upload_images')

        # Build an object to provide workflow/tool parameters.
        parameters = {}
        parameters[step.id] = 
          file_ids: file_ids

        payload = 
          history: "hist_id=#{dataset.history_id}"
          workflow: workflow.id
          parameters: parameters

        workflow.invoke(payload).then (response) =>
          @successMessage = "Workflow has been invoked. Please refresh your history!"
          
    return

  ]
