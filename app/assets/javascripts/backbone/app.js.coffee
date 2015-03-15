#= require_self
#= require hamlcoffee
#= require_tree ../templates
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.App =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Mixins: {}
  Variables: {}
  Settings: {
    API_URL: '/api/v1'
  }

$ ->
  App.Routers.mainRouter = new App.Routers.AppRouter()

initMultipleSelect = (element) ->
  $(element).select2
    width: "400px"
    placeholder: "Search for Makerble users"
    multiple: true
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
      ids = $(element).val() # ex: [10, 11]
      $(element).val("")
      ids = ids[1..ids.length-2]
      ids = ids.split(',')
      for id in ids
        datas = []
        unless id is ""
          $.ajax("#{App.Settings.API_URL}/users/#{id}",
            dataType: "json"
          ).done (data) ->
            datas.push { id: data['id'], name: data['name'] }
            if datas.length is ids.length
              callback datas
App.initMultipleSelect = initMultipleSelect
