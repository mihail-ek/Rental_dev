class PreviewImage
  constructor: (el) ->
    @$el = $(el)
    @setPreviewImage(@$el.data('src'), @$el.data('title'))
    @bindChange()

  preview: (f) ->
    return unless f.type.match("image.*")

    reader = new FileReader()
    reader.onload = ((file) =>
      (e) =>
        src = e.target.result
        title = escape(file.name)
        @setPreviewImage(src, title)
    )(f)

    reader.readAsDataURL f

  setPreviewImage: (src, title) ->
    return unless src
    template = _.template($('#image-preview-template').html())
    data =
      src: src
      title: title
    $imagePreview = @$el.siblings('.image-preview')
    if $imagePreview.length > 0
      $imagePreview.remove()
    @$el.before(template(data))

  bindChange: ->
    @$el.on 'change', (event) =>
      @preview(event.target.files[0])

$.fn.previewImage = ->
  $(this).each (index, input) ->
    new PreviewImage(input)
