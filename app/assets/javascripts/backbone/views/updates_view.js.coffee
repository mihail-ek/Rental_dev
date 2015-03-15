App.Views ||= {}

class App.Views.UpdatesView extends Backbone.View
  el: "body"
  events:
    "click .like-an-update": 'likeAnUpdateButtonClicked'
    "click .comment-an-update": 'commentAnUpdateButtonClicked'
    "click .comments .submit .btn": 'addACommentToAnUpdate'

  likeAnUpdateButtonClicked: (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    likableId = $(target).data('likable-id')
    likableType = $(target).data('likable-type')
    user = new App.Models.User()
    previousCount = parseInt($(target).find('.number').attr('data-count'))
    if $(target).attr('data-active') is 'true'
      user.unlikeAnUpdate(likableId, likableType).complete (jqXHR, textStatus) =>
        if textStatus == "success"
          $(target).attr('data-active', 'false')
          $(target).find('.text').html('Fav')
          $(target).find('.number').attr('data-count', previousCount - 1)
          $(target).find('.number').html("(#{previousCount - 1})")
    else
      user.likeAnUpdate(likableId, likableType).complete (jqXHR, textStatus) =>
        if textStatus == "success"
          $(target).attr('data-active', 'true')
          $(target).find('.text').html('Unfav')
          $(target).find('.number').attr('data-count', previousCount + 1)
          $(target).find('.number').html("(#{previousCount + 1})")

  commentAnUpdateButtonClicked: (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    $(target).parents('.boxcontainer').find('.comments').toggle()
    scrollable = $(target).parents('.boxcontainer').find('.comments-list')
    if $(scrollable).find('.comment').length > 3
      unless $(scrollable).hasClass('jspScrollable')
        $(scrollable).jScrollPane()
        scrollableApi = $(scrollable).data('jsp')
        scrollableApi.reinitialise()
        scrollableApi.scrollToBottom()
    $('.isotope').isotope()
    
  addACommentToAnUpdate: (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    text = $(target).parents('.submit').find('textarea').val()
    unless text is ''
      commentableId = $(target).data('commentable-id')
      commentableType = $(target).data('commentable-type')
      comment = new App.Models.Comment()
      comment.set 'text', text
      comment.set 'commentable_type', commentableType
      comment.set 'commentable_id', commentableId
      comment.save({},
        success: (model, response) ->
          $(target).parents('.submit').find('textarea').val('')
          scrollable = $(target).parents('.boxcontainer').find('.comments-list')
          if $(scrollable).hasClass('jspScrollable')
            $(target).parents('.comments').find('.comments-list .jspPane').append("<div class='comment'><span class='user'>Me</span> #{text}</div>")
            scrollableApi = $(scrollable).data('jsp')
            scrollableApi.reinitialise()
            scrollableApi.scrollToBottom()
          else
            $(target).parents('.comments').find('.comments-list').append("<div class='comment'><span class='user'>Me</span> #{text}</div>")
            $('.isotope').isotope()
            $(scrollable).css 'max-height', 'none'
      )
