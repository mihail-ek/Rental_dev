App.Views ||= {}

class App.Views.UserView extends Backbone.View
  initialize: ->
    if $('.alert-error').length > 0
      @showFormToChangePassword()
  el: "body"
  events:
    "click .follow-user": 'followButtonClicked'
    "click .change-password-link": 'showFormToChangePassword'

  followButtonClicked: (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    action = if $(event.currentTarget).attr('data-active') is 'true'
               'unfollow'
             else
               'follow'
    $.ajax(
      type: "POST"
      url: App.Settings.API_URL + "/users/#{action}"
      data:
        user_id: $(target).data('user-id')
      success: ->
        if action is 'follow'
          name = 'unfollow'
          isActive = 'true'
        else
          name = 'follow'
          isActive = 'false'
        $(target).find('.name').html(name)
        $(target).attr('data-active', isActive)
    )

  showFormToChangePassword: (event = null) ->
    event.preventDefault() if event
    $('.change-password-link').hide()
    $('.change-password').show()
