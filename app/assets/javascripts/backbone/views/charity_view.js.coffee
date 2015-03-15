App.Views ||= {}

class App.Views.CharityView extends Backbone.View
  el: "body"
  events:
    "click .follow-charity": 'followButtonClicked'

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
        charity_id: $(target).data('charity-id')
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
