class App.Models.LifestyleCheckout extends Backbone.Model
  urlRoot: App.Settings.API_URL + '/lifestyle_checkouts'

class App.Collections.LifestyleCheckoutsCollection extends Backbone.Collection
  model: App.Models.LifestyleCheckout
  url: App.Settings.API_URL + '/lifestyle_checkouts'
