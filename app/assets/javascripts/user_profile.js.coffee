$ ->
  $("a.popover-with-html").click (event) ->
    event.preventDefault()
  $("a.popover-with-html.placement-left").popover
    html: "true"
    placement: "left"
  $("a.popover-with-html.placement-right").popover
    html: "true"
    placement: "right"

  $('.nav-tabs a').click ->
    setTimeout (->
      $('.isotope').isotope()
    ), 800
