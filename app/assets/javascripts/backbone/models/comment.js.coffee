class App.Models.Comment extends Backbone.Model
  urlRoot: App.Settings.API_URL + '/comments'

class App.Collections.CommentsCollection extends Backbone.Collection
  model: App.Models.Comment
  url: App.Settings.API_URL + '/comments'
