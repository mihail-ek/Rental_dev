class App.Models.User extends Backbone.Model
  urlRoot: App.Settings.API_URL + '/users'

  me: ->
    @fetch {
      url: App.Settings.API_URL + '/users/me'
    }
  
  facebookconnect: (facebookToken) ->
    @fetch {
      url: App.Settings.API_URL + '/users/facebookconnect'
      data: { facebookToken: facebookToken }
    }
  
  cartSubscriptionToPlan: (isGiftAid) ->
    @fetch {
      url: App.Settings.API_URL + '/users/cart_subscription_to_plan'
      data: { isGiftAid: isGiftAid }
    }
  
  updateCauses: (ids) ->
    @fetch {
      url: App.Settings.API_URL + '/users/update_causes'
      data: { ids: ids }
    }
   
  getPlaces: (names) ->
    @fetch {
      url: App.Settings.API_URL + '/users/get_places'
    }

  updatePlaces: (names) ->
    @fetch {
      url: App.Settings.API_URL + '/users/update_places'
      data: { places: names }
    }

  updateIntelligentMatching: (value = false) ->
    @fetch {
      url: App.Settings.API_URL + '/users/update_intelligent_matching'
      data: { value: value }
    }

  likeAnUpdate: (likableId, likableType) ->
    @fetch {
      url: App.Settings.API_URL + '/users/like_an_update'
      data: { likable_id: likableId, likable_type: likableType }
    }

  unlikeAnUpdate: (likableId, likableType) ->
    @fetch {
      url: App.Settings.API_URL + '/users/unlike_an_update'
      data: { likable_id: likableId, likable_type: likableType }
    }

class App.Collections.UsersCollection extends Backbone.Collection
  model: App.Models.User
  url: App.Settings.API_URL + '/users'
