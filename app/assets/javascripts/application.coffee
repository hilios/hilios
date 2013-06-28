#= require paper
#= require spin
#= require jquery
#= require jquery.spin
#= require jquery.inview
#= require underscore
#= require backbone
#= require_self
#= require_tree .

String::constantize = ->
  "-#{@}".replace /-+(.)?/g, (match, chr)-> 
    if chr then chr.toUpperCase() else ''

app = _.extend {}, Backbone.Events,

  _instances: {}

  register: (name, instance)->
    if name in instance
      throw "Instace for #{name} cannot be override!"
    
    @_instances[name] = instance

  pkg: (name) ->
    @_instances[name]

  run: ->
    $('[data-view]').each (index, el)=>
      viewName = $(el).data('view').constantize()
      view = new (@pkg("views.#{viewName}"))(el: el)

$ -> app.run()

window.app = app