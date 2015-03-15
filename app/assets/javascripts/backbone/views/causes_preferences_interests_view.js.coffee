App.Views ||= {}

class App.Views.CausesPreferencesInterestsView extends Backbone.View
  @include App.Mixins.Facebook

  initialize: ->
    @user = new App.Models.User()

  el: "body"
  events:
    "click #causes-preferences-interests .call-to-action": 'nextButtonClicked'
    "click #causes-preferences-interests .back": 'backButtonClicked'
    "click #causes-preferences-interests .switch-button a": 'switchButtonClicked'

  nextButtonClicked: (event) ->
    event.preventDefault()
    if $('#causes-preferences-interests .switch-button .sprites-switch-on').length > 0
      @facebookConnect(@gotoNextPage)
    else
      @gotoNextPage()

  backButtonClicked: (event) ->
    event.preventDefault()
    $('.causes-preferences .nav li.places a').trigger 'click'

  switchButtonClicked: (event) ->
    event.preventDefault()
    value = $('#causes-preferences-interests .switch-button .sprites-switch-on').length > 0
    @user.updateIntelligentMatching(value)

  gotoNextPage: ->
    $('.causes-preferences .nav li.collect a').trigger 'click'
