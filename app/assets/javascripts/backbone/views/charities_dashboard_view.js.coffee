App.Views ||= {}

class App.Views.CharitiesDashboardView extends Backbone.View
  el: "#charities-dashboard"
  events:
    "click .nav li": 'navClicked'

  navClicked: (event) ->
    $target = $(event.currentTarget)
    if $target.attr('data-name') and !$target.hasClass('active')
      name = $target.data 'name'
      App.Routers.mainRouter.navigate "charities/dashboard/#{name}", {trigger: true}
      $("html, body").animate({ scrollTop: 0 })
