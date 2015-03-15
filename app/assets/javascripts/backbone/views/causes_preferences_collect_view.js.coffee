App.Views ||= {}

class App.Views.CausesPreferencesCollectView extends Backbone.View
  initialize: ->
    @failedNumber = 0
    @addMoreProjects()

  el: "body"
  events:
    "click #projects-to-add .select": "selectClicked"
    "click .add-more-projects": "addMoreProjects"
    "click .project-to-add .swap": "swapProject"
    "click .project-to-add .go-back": "goBackToProject"
    "click #collect .back": 'backButtonClicked'

  updateBasket: =>
    $.ajax
      url: App.Settings.API_URL + '/users/cart_clear'
      success: (data) ->
        $('.sprites-select').parents('.project-to-add').each (index, element) =>
          projectId = $(element).data('project-id')
          $.ajax
            url: App.Settings.API_URL + '/users/cart_add'
            data:
              project_id: projectId
              price: 0
            success: (data) ->
              $('.sprites-basket .count').html(data.length)

  addMoreProjects: (event = null) ->
    event.preventDefault() if event
    $('.add-more-projects').hide()
    $('#projects-to-add').append('<div class="row projects-to-add"></div>')
    @addOne()

  swapProject: (event) ->
    event.preventDefault()
    target = $(event.currentTarget).parents('.project-to-add')[0]
    @addOne(target)

  goBackToProject: (event) ->
    event.preventDefault()
    target = $(event.currentTarget).parents('.project-to-add')[0]
    projectId = $(target).data('previous-project-id')
    @addOne(target, projectId)

  addOne: (target = null, projectId = 0) ->
    project = new App.Models.Project()
    project.suggested(projectId).complete (jqXHR, textStatus) =>
      if textStatus == "success"
        if target
          if projectId != 0 or ($("*[data-project-id='#{project.id}']").length < 1 and $("*[data-previous-project-id='#{project.id}']").length < 1)
            previousProjectID = if projectId is 0 then $(target).data('project-id') else null
            $(target).before JST["projects/to_add"](project: project.toJSON(), previousProjectID: previousProjectID)
            @updateBasket()
            $(target).remove()
          else
            @failedNumber += 1
            @addOne(target)
        else
          if $("*[data-project-id='#{project.id}']").length < 1 and $("*[data-previous-project-id='#{project.id}']").length < 1
            $('#projects-to-add > div:last-of-type').append JST["projects/to_add"](project: project.toJSON(), previousProjectID: null)
            @updateBasket()
          else
            @failedNumber += 1

          if $('#projects-to-add > div:last-of-type > div').length < 3
            @addOne() if @failedNumber < 20
          else
            $('.add-more-projects').show()

  selectClicked: (event) ->
    event.preventDefault()
    target = event.currentTarget
    if $(target).find('.sprites-select').length > 0
      $(target).find('div').removeClass 'sprites-select'
      $(target).find('div').addClass 'sprites-select-inactive'
    else
      $(target).find('div').removeClass 'sprites-select-inactive'
      $(target).find('div').addClass 'sprites-select'
    @updateBasket()

  backButtonClicked: (event) ->
    event.preventDefault()
    $('.causes-preferences .nav li.interests a').trigger 'click'
