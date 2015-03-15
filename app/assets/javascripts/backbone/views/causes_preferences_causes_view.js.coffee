App.Views ||= {}

class App.Views.CausesPreferencesCausesView extends Backbone.View
  el: "body"
  events:
    "click .choices .bloc": 'blocClicked'
    "click .tags .tag": 'tagClicked'
    "click #causes-preferences-causes .call-to-action": 'nextButtonClicked'

  blocClicked: (event) ->
    event.preventDefault()
    target = event.currentTarget
    if $(target).hasClass 'active'
      $(target).removeClass 'active'
      $("#causes-preferences-causes .tags .tag[data-id=#{$(target).data('id')}]").remove()
    else
      $(target).addClass 'active'
      $('#causes-preferences-causes .tags').append JST["shared/tag"](id: $(target).data('id'), icon: $(target).data('icon'), name: $(target).data('name'))
    
    @user = new App.Models.User()
    ids = []
    $('#causes-preferences-causes .tags .tag').each (index, element) ->
      ids.push $(element).data('id')
    @user.updateCauses(ids.join())

  tagClicked: (event) ->
    event.preventDefault()
    target = event.currentTarget
    $(".choices .bloc[data-id=#{$(target).data('id')}]").trigger 'click'
    
  nextButtonClicked: (event) ->
    event.preventDefault()
    $('.causes-preferences .nav li.places a').trigger 'click'
