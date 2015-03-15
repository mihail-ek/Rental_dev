App.Views ||= {}

class App.Views.CheckoutPaymentConfirmationView extends Backbone.View
  el: "body"
  events:
    "click .nav li": 'navClicked'

  navClicked: (event) ->
    target = event.currentTarget
    unless $(target).hasClass 'active'
      name = $(target).attr 'class'
      if $(target).find('a').attr('data-toggle') is 'tab'
        App.Routers.mainRouter.navigate name, {trigger: true}
