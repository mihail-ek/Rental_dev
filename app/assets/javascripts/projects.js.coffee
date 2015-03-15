window.App ||= {}

$ ->
  App.updatePrice()
  App.initMultipleSelect($('#project_editor_ids'))
  App.initMultipleSelect($('#project_reporter_ids'))
  $('#total-price').show()
  $('.project_projects_makes_cost input').live 'keyup', -> # TODO update to last version of JQuery
    App.updatePrice()
  $('.remove_fields').live 'click', ->
    setTimeout(
      App.updatePrice
    , 500)

  $('#project_problem_list, #project_problem_statistic_list, #project_tag_list, #project_method_list, #project_change_tag_list').select2
    tags: [],
    tokenSeparators: [","]
    width: "400px"

  $('.sub-causes-input').each ->
    existingSubCauses = $(this).data('subcauses').split(',')
    $(this).select2
      tags: existingSubCauses,
      tokenSeparators: [","]
      width: "400px"

updatePrice = ->
  totalPrice = 0
  $('.project_projects_makes_cost input').each (index, element) ->
    if $(@).parents('.nested-fields').css('display') isnt 'none'
      totalPrice += parseInt($(element).val())
  $('#total-price .price').html "£#{totalPrice}"
App.updatePrice = updatePrice
