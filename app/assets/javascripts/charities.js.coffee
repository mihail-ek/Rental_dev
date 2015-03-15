$ ->
  App.initMultipleSelect($('#charity_editor_ids'))
  App.initMultipleSelect($('#charity_reporter_ids'))

$("#charity_leader_id").select2
  placeholder: "Search for a Makerble user"
  minimumInputLength: 2
  ajax:
    url: "#{App.Settings.API_URL}/users/search"
    dataType: "json"
    data: (term, page) ->
      query: term
    results: (data, page) ->
      results: data
  formatResult: (item) -> item.name
  formatSelection: (item) -> item.name
  escapeMarkup: (m) -> m

  initSelection: (element, callback) ->
    id = $(element).val()
    if id isnt ""
      $.ajax("#{App.Settings.API_URL}/users/#{id}",
        dataType: "json"
      ).done (data) ->
        callback data
