$ ->
  $('#ways-to-get-started .causes a').click ->
    mixpanel.track(
      'Get started',
      { 'Choice type': 'Cause' }
    )
  $('#ways-to-get-started .projects a').click ->
    mixpanel.track(
      'Get started',
      { 'Choice type': 'Project' }
    )
  $('#ways-to-get-started .bundle a').click ->
    mixpanel.track(
      'Get started',
      { 'Choice type': 'Bundle' }
    )
