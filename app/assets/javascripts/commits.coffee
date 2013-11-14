$ ->
  $(document).on({
    mouseenter: (eventObject) ->
      $(this).find(".add-tag").removeClass("hidden")
    mouseleave: (eventObject) ->
      $(this).find(".add-tag").addClass("hidden")
  }, "tr")
