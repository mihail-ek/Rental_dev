class App.Models.CharityJoinRequest extends Backbone.Model
  urlRoot: App.Settings.API_URL + '/charity_join_requests'

class App.Collections.CharityJoinRequestsCollection extends Backbone.Collection
  model: App.Models.CharityJoinRequest
  url: App.Settings.API_URL + '/charity_join_requests'

  pending: ->
    @fetch {
      url: App.Settings.API_URL + '/charity_join_requests/pending'
    }
