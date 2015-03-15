App.Views ||= {}

class App.Views.PaymentView extends Backbone.View
  @include App.Mixins.Facebook
  initialize: ->
    @gotoStepTwo()

  el: "body"
  events:
    # "click #sign-in-with-facebook": 'signInWithFacebookClicked'
    "click #step2 .btn": 'gotoStepThree'
    
  signInWithFacebookClicked: (event) ->
    event.preventDefault()
    @facebookConnect(@gotoStepTwo, @signInWithDevise)
      
  gotoStepTwo: ->
    $('#step1').hide()
    $('#step2').show()
      
  gotoStepThree: (event) ->
    event.preventDefault()
    $('#step2').hide()
    $('#step3').show()
    @cartSubscriptionToPlan()
    
  cartSubscriptionToPlan: ->
    type = if App.Variables.paymentType is 'subscription'
             'subscription'
           else
             'charge'
    selectedCheckboxes = $('#step2 input[type="checkbox"]:checked')
    ids = (elem.id.substr(17, 10) for elem in selectedCheckboxes)
    $('#stripe-form form').attr('action', "/stripe/create_#{type}s/#{ids.toString()}")
