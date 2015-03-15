include = (mixins...) ->
  unless mixins and mixins.length > 0
    throw new Error('include(mixins...) requires at least one mixin')

  for mixin in mixins
    for key, value of mixin
      @::[key] = value unless key is 'included'

    mixin.included?.apply(this)
  this

Backbone.Model.include = Backbone.Collection.include = include
Backbone.View.include = Backbone.Router.include = include
