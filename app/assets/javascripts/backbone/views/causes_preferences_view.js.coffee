App.Views ||= {}

class App.Views.CausesPreferencesView extends Backbone.View
  el: "body"
  events:
    "click .causes-preferences .nav li": 'navClicked'

  navClicked: (event) ->
    target = event.currentTarget
    unless $(target).hasClass 'active'
      name = $(target).attr 'class'
      unless name in ['checkout', 'my-home']
        App.Routers.mainRouter.navigate "causes-preferences-#{name}", {trigger: true}
        $("html, body").animate({ scrollTop: 0 })
      # if name is 'checkout'
      #   App.Routers.mainRouter.navigate "#{name}", {trigger: true}
