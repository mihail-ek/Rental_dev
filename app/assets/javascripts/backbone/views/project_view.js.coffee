App.Views ||= {}

class App.Views.ProjectView extends Backbone.View
  el: "body"
  events:
    "click .faq .submit.btn-large": 'faqQuestionSubmitted'
    "click .faq-item .submit": 'faqAnswerSubmitted'
    "click .faq-item": 'faqItemClicked'
    "click .faq-item .delete": 'faqDeleteClicked'

  faqItemClicked: (event) ->
    event.preventDefault()

  faqQuestionSubmitted: (event) ->
    event.preventDefault()
    question = $('.faq #question_content').val()
    question = question[0..254]
    unless question is ''
      faq = new App.Models.Faq()
      projectId = $(event.currentTarget).data('project-id')
      faq.set('project_id', projectId)
      faq.save {},
        success: (model, response) ->
          comment = new App.Models.Comment()
          comment.set('commentable_type', 'Faq')
          comment.set('commentable_id', model.id)
          comment.set('text', question)
          comment.save {},
            success: (model, response) ->
              location.reload()

  faqAnswerSubmitted: (event) ->
    event.preventDefault()
    answer = $(event.currentTarget).parents('li').find('.answer_content').val()
    if answer
      answer = answer[0..254]
      unless answer is ''
        questionId = $(event.currentTarget).data('question-id')
        comment = new App.Models.Comment()
        comment.set('commentable_type', 'Comment')
        comment.set('commentable_id', questionId)
        comment.set('text', answer)
        comment.save {},
          success: (model, response) ->
            location.reload()

  faqDeleteClicked: (event) ->
    event.preventDefault()
    faqId = $(event.currentTarget).parents('li').data('faq-id')
    faq = new App.Models.Faq({ id: faqId })
    faq.fetch
      success: ->
        faq.destroy
          success: (model, response) ->
            $(event.currentTarget).remove()
