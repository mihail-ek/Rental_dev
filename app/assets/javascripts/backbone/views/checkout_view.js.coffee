App.Views ||= {}
App.Variables ||= {}

class App.Views.CheckoutView extends Backbone.View
  initialize: ->
    @totalPrice = 0
    App.Variables.paymentType = 'subscription'
    @lifestyleCheckouts = new App.Collections.LifestyleCheckoutsCollection()
    @lifestyleCheckouts.fetch
      success: =>
        @failedNumber = 0
        App.Collections.selectedProjects = new App.Collections.ProjectsCollection()
        @selectedProjects = App.Collections.selectedProjects
        @selectedProjects.selected().complete (jqXHR, textStatus) =>
          if textStatus == "success"
            @selectedProjects.each @addOneSelectedProject
            @initBasketRows()
            @showBasket()
            @suggestedProjects = new App.Collections.ProjectsCollection()
            @addOneSuggestedProject()
        @initVouchRow()

  el: "body"
  events:
    "click .btn-next": 'nextButtonClicked'
      
  nextButtonClicked: (event) ->
    event.preventDefault()
    if @totalPrice > 0
      App.Variables.paymentType = if $(event.currentTarget).hasClass('one-off-donation') then 'one-off' else 'subscription'
      @updatePrices()
      target = $('.nav li.payment a')
      $(target).trigger 'click'

  enableNextButtons: =>
    target = $('.nav li.payment a')
    if @totalPrice > 0
      $('.btn-next').removeClass('disabled')
      target.attr('data-toggle', 'tab')
      target.attr('href', '#payment')
    else
      $('.btn-next').addClass('disabled')
      target.attr('data-toggle', 'tab-inactive')
      target.attr('href', '#')

  updatePrices: ->
    $.ajax
      url: App.Settings.API_URL + '/users/cart_clear' # clear the prices of the db
      success: (data) =>
        $('.selected-project .active[data-price]').each (index, element) =>
          projectId = parseInt($(element).parents('.selected-project').data('project-id'))
          project = @selectedProjects.get(projectId)
          if project
            project.set price: parseInt($(element).attr('data-price'))
            
            # update prices in the db
            $.ajax
              url: App.Settings.API_URL + '/users/cart_add'
              data:
                project_id: project.id
                price: project.get('price')

        total = 0
        $('.project-basket-price').remove()
        @selectedProjects.each (element) =>
          if element.get('price')
            total += element.get('price')
            price = element.get('price')
            name = if price in [3, 5, 10, 20]
                     if price is 3
                       '1 x Cappuccino'
                     else if price is 5
                       '1 x Round of drinks'
                     else if price is 10
                       '1 x Cinema ticket'
                     else if price is 20
                       '1 x Gym fee'
                   else
                     "Other amount"
            $('.sub-total').before JST["checkout/basket"](name: name, price: element.get('price'))
          
        vouchPrice = $('#buy-a-friend-a-gift-voucher .active').attr('data-price')
        if vouchPrice
          $('.sub-total').before JST["checkout/basket"](name: 'Gift voucher', price: vouchPrice)
          total += parseInt(vouchPrice)
        if App.Variables.paymentType is 'subscription'
          panelLabelText = "Subscribe"
          paymentAmountText = "£#{total}/month"
          stripeButtonText = "Pay by card"
        else
          panelLabelText = "Donate"
          paymentAmountText = "£#{total}"
          stripeButtonText = "Donate with Card"
        $('.sub-total .price').html "£#{total}.00"
        $('.total-price').html "£#{total}.00"
        $('#payment-steps .amount').html(paymentAmountText)
        $('#stripe-checkout-button').html(stripeButtonText)
        $("#stripe-checkout-button").click ->
          token = (res) ->
            $input = $("<input type=hidden name=stripeToken />").val(res.id)
            $("form").append($input).submit()
          StripeCheckout.open
            key: STRIPE_PUBLISHABLE_KEY,
            address: true
            amount: total * 100
            currency: "gbp"
            name: "Makerble"
            panelLabel: panelLabelText
            token: token
          false
        @totalPrice = total
        @enableNextButtons()

  initVouchRow: =>
    $('.vouch-row').append JST["projects/basket_row"](name: 'Choose amount', items: @lifestyleCheckouts.toJSON(), interval: 'month')
    @initBasketRows()
    $('#buy-a-friend-a-gift-voucher .accordion-heading a').trigger('click')

  addOneSuggestedProject: ->
    suggestedProject = new App.Models.Project()
    suggestedProject.suggested().complete (jqXHR, textStatus) =>
      if textStatus == "success"
        if $("*[data-project-id='#{suggestedProject.id}']").length < 1
          $('.suggested-projects').append JST["projects/you_might_like"](project: suggestedProject.toJSON())
          $('#list-of-projects-you-might-like .basket-list').hide()
          @suggestedProjects.add suggestedProject
          @initSuggestedProjects()
        else
          @failedNumber += 1
          
        if $('.suggested-project').length < 4
          @addOneSuggestedProject() if @failedNumber < 5
        
        if $('.suggested-project').length is 1
          $("#other-projects-you-might-like").show()
          $('#other-projects-you-might-like .accordion-heading a').trigger('click')

  addOneSelectedProject: (element, index, list) =>
    $("#projects-and-bundles-list .list").append JST["projects/basket_row"](project: element.toJSON(), items: @lifestyleCheckouts.toJSON(), interval: 'month')
 
  showBasket: ->
    $('#choosen-projects-and-bundles .accordion-heading a').trigger('click')

  initSuggestedProjects: ->
    $('.suggested-project').click (event) =>
      event.preventDefault()
      projectId = $(event.currentTarget).data('project-id')
      if $("#list-of-projects-you-might-like .list *[data-project-id='#{projectId}']").length < 1
        $('#list-of-projects-you-might-like .basket-list').show()
        suggestedProject = @suggestedProjects.get(projectId)
        $('#list-of-projects-you-might-like .list').append JST["projects/basket_row"](project: suggestedProject.toJSON(), items: @lifestyleCheckouts.toJSON(), interval: 'month')
        @selectedProjects.add suggestedProject
        @initBasketRows()
        @updatePrices()

  initBasketRows: ->
    $("a.infos").tooltip { placement: "right" }

    select = ".pages.checkout"
    $("#{select}").find(".bloc").click (event) =>
      event.preventDefault()
      target = event.currentTarget
      $(target).parents('tr').find('.active').each (index, element) ->
        $(element).find('.title').css('color', '#000')
        $(element).removeClass 'active'
      $(target).parents('tr').find('input').val('')
      $(target).addClass 'active'
      color = $(target).data('color')
      $(target).find('.title').css('color', color)
      $(target).parents('tr').find('.bloc').each (index, element) ->
        sprite = $(element).find('div')[1]
        formerClass = $(sprite).attr('class')
        newClass = if $(element).hasClass 'active'
                     "sprites-#{$(sprite).data('name')}-checkout"
                   else
                     "sprites-#{$(sprite).data('name')}-checkout-inactive"
        $(sprite).removeClass formerClass
        $(sprite).addClass newClass
      @updatePrices()
      
    $("#{select}").find("input").focus (event) =>
      target = event.currentTarget
      $(target).parents('tr').find('.bloc').removeClass 'active'
      $(target).attr 'data-price', '0'
      $(target).addClass 'active'
      @updatePrices()
    $("#{select}").find("input").numeric({ decimal: false, negative: false })
    $("#{select}").find("input").keyup (event) =>
      target = event.currentTarget
      keyCode = if event.keyCode then event.keyCode else event.which
      if keyCode > 47 and keyCode < 58
        price = if $(target).val() is '' then 0 else $(target).val()
        $(target).attr 'data-price', parseInt(price)
        @updatePrices()
