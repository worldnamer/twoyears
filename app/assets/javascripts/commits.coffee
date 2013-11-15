$ ->
  $(document).on({
    mouseenter: (eventObject) ->
      $(this).find(".add-tag").removeClass("hidden")
    mouseleave: (eventObject) ->
      $(this).find(".add-tag").addClass("hidden")
  }, "tr")

$ ->
  $(document).on({
    keyup: (eventObject) ->
      $scope = angular.element($(this)).scope()
      key = eventObject.which

      val = $(this).val()
      if val.length > 0
        switch key
          when 9 # tab
            eventObject.preventDefault()
            $scope.$emit('addTag', $scope.commit, val)
            $(this).val("")

          when 13 # return
            eventObject.preventDefault()
            $scope.$emit('addTag', $scope.commit, val)
            $(this).val("")

    keydown: (eventObject) ->
      $scope = angular.element($(this)).scope()
      key = eventObject.which
      val = $(this).val()
      switch key
        when 8 # backspace
          val = $(this).val()
          if val.length == 0
            commit = $scope.commit
            $scope.$emit('removeTag', commit, commit.tags.length - 1)

        when 9 # tab
          if val.length > 0
            eventObject.preventDefault()
  }, "tr input")