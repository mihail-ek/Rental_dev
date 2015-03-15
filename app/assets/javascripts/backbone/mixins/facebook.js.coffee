App.Mixins ||= {}

App.Mixins.Facebook =
  facebookConnect: (todoNext = null, callback = null) ->
    FB.getLoginStatus (response) =>
      if response.status is 'connected'
        if callback then callback(response, todoNext) else todoNext()
      else
        FB.login (response, todoNext) =>
          if response.authResponse
            if callback then callback(response, todoNext) else todoNext()
        , { scope: 'email publish_stream' }

  signInWithDevise: (response, todoNext) ->
    accessToken = response.authResponse.accessToken
    @user = new App.Models.User()
    @user.facebookconnect(accessToken).complete (jqXHR, textStatus) =>
      if textStatus == "success"
        App.Models.currentUser = @user
        todoNext()
