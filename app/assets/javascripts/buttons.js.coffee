$ ->
  $(".switch-button").click (event) ->
    event.preventDefault()
    target = event.currentTarget
    switchOn = $(target).find('.sprites-switch-on')
    if $(switchOn).length > 0
      $(switchOn).removeClass 'sprites-switch-on'
      $(switchOn).addClass 'sprites-switch-off'
    else
      switchOff = $(target).find('.sprites-switch-off')
      $(switchOff).removeClass 'sprites-switch-off'
      $(switchOff).addClass 'sprites-switch-on'

  $('.accordion-toggle').click (event) ->
    target = event.currentTarget
    plus = $(target).find('.sprites-plus')
    if $(plus).length > 0
      $(plus).removeClass 'sprites-plus'
      $(plus).addClass 'sprites-minus-sign'
    else
      minus = $(target).find('.sprites-minus-sign')
      $(minus).removeClass 'sprites-minus-sign'
      $(minus).addClass 'sprites-plus'
