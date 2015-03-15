class AddOtherInputBehavior
  constructor: (el) ->
    @$el = $(el)
    @$enumTypes = @$el.find('.enum_type')
    @other = @$enumTypes.first().find('select').data('otherregulator')
    @bindFormSubmit()
    @bindSelectChange()
    @initOtherInput()

  bindFormSubmit: ->
    @$el.submit (event) =>
      $(event.target).find('.enum_type').each (index, elem) =>
        $enumType = $(elem)
        $selectedOption = $enumType.find('option:selected')
        $selectOtherInput = $enumType.find('.select-other-input')
        if $selectedOption.text() is @other
          $selectedOption.attr('value', $selectOtherInput.val())

  bindSelectChange: ->
    @$enumTypes.find('select').change (event) =>
      $selectInput = $(event.target)
      selectedText = $selectInput.find('option:selected').text()
      $selectOtherInput = $selectInput.siblings('.select-other-input')
      if selectedText is @other
        $selectOtherInput.prop('disabled', false)
      else
        $selectOtherInput.prop('disabled', true)

  initOtherInput: ->
    @$enumTypes.each (index, elem) =>
      $enumType = $(elem)
      if $enumType.find('option:selected').text() is @other
        $selectOtherInput = $enumType.find('.select-other-input')
        $selectOtherInput.prop('disabled', false)
        $selectOtherInput.val($enumType.find('select').data('othervalue'))

$.fn.addOtherInputBehavior = ->
  new AddOtherInputBehavior(this)
