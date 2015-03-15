App.Views ||= {}

class App.Views.CausesPreferencesPlacesView extends Backbone.View
  initialize: ->
    @user = new App.Models.User()
    @handleMap()

  el: "body"
  events:
    "click #causes-preferences-places .call-to-action": 'nextButtonClicked'
    "click #causes-preferences-places .back": 'backButtonClicked'
   
  tagClicked: (event) ->
    event.preventDefault()
    id = $(event.currentTarget).data('id')
    $("area[data-key=#{id}]").mapster('deselect')
    $(event.currentTarget).remove()
    @savePlaces()

  addTag: (id, name) ->
    $('#causes-preferences-places .tags').append JST["shared/tag"](id: id, name: name)
    tag = $("#causes-preferences-places .tags .tag[data-id=#{id}]")
    $(tag).click (event) =>
      @tagClicked(event)
    @savePlaces()

  savePlaces: ->
    @user.updatePlaces(@getTags().join())
    
  nextButtonClicked: (event) ->
    event.preventDefault()
    $('.causes-preferences .nav li.interests a').trigger 'click'
    
  backButtonClicked: (event) ->
    event.preventDefault()
    $('.causes-preferences .nav li.causes a').trigger 'click'

  getTags: ->
    locations = []
    $('#causes-preferences-places .tag').each (index, element) ->
      locations.push $(element).data('id')
    locations

  handleMap: ->
    $('img').mapster
      mapKey: 'data-key'
      render_select:
        altImage: "assets/common/map_highlighted.png"
      render_highlight:
        altImage: "assets/common/map_highlighted.png"
      areas: [
        key: 'rest'
      ,
        key: 'uk'
      ]
      onClick: (data) =>
        id = data.key
        tag = $("#causes-preferences-places .tags .tag[data-id=#{id}]")
        if $(tag).length > 0
          $(tag).remove()
        else
          country = $(data.e.target).data('country')
          mixpanel.track(
              'Cause info',
              { 'Location': country }
          )
          @addTag(id, country)
      onConfigured: =>
        @user.getPlaces().complete (jqXHR, textStatus) =>
          if textStatus == "success"
            for key, place of @user.attributes
              $("area[data-key=#{place}]").trigger('click')
