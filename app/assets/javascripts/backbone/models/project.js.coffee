class App.Models.Project extends Backbone.Model
  urlRoot: App.Settings.API_URL + '/projects'

  suggested: (id = 0) ->
    @fetch {
      url: App.Settings.API_URL + '/projects/suggested'
      data: { project_id: id }
    }

class App.Collections.ProjectsCollection extends Backbone.Collection
  model: App.Models.Project
  url: App.Settings.API_URL + '/projects'

  selected: ->
    @fetch {
      url: App.Settings.API_URL + '/projects/selected'
    }
