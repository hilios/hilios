#= require spin
#= require jquery
#= require jquery.spin
#= require jquery.inview
#= require underscore
#= require backbone
#= require_self
#= require_tree .

app = 
  views: {}

  start: ->
    $('data-view').each ->
      viewName = @.data('view')
      view = app.views[viewName](el: this)

$ ->
  app.start()