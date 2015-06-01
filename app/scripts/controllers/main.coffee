'use strict'

###*
 # @ngdoc function
 # @name imageSelectorAppApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the imageSelectorAppApp
###
angular.module 'imageSelectorAppApp'
  .controller 'MainCtrl', ['$http', '$scope', ($http, $scope) ->

    @selectedImages = {}
    @imagesPerPage = 9
    @currentPage = 1

    @pageCount = =>
      return Math.ceil(@images.length / @imagesPerPage)

    # Load images from /images.json and attach them to the scope.
    $http.get('images.json')
      .success (response) =>
        @images = response.data

        @totalImages = @images.length

        $scope.$watch ($scope) =>
          @currentPage + @imagesPerPage
        , =>
          begin = (@currentPage-1) * @imagesPerPage
          end = begin + @imagesPerPage
          @filteredImages = @images.slice(begin, end)

      .error (data) =>
        console.log 'Unable to fetch images.json'

    @toggle = (imageId) ->
      @selectedImages[imageId] = !@selectedImages[imageId]

    @isSelected = (imageId) ->
      !!@selectedImages[imageId]

    return
  ]
