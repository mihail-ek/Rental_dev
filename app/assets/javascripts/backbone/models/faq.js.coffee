class App.Models.Faq extends Backbone.Model
  url: ->
    url = App.Settings.API_URL
    url += "/faqs"
    url += "/#{@id}" if @id != undefined
    url

class App.Collections.FaqsCollection extends Backbone.Collection
  model: App.Models.Faq
  url: App.Settings.API_URL + '/faqs'
