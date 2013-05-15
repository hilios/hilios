app.views.posts = Backbone.View.extend
  page: 0

  events:
    'inview': 'paginate'

  paginate: (event, isInView, visiblePartX, visiblePartY)->
    if visiblePartY is 'bottom' and not @hasSpin()
      $spin = $('<div class="spin"></div>')
      $spin.appendTo(event.target)
      $spin.spin('large')

  hasSpin: ->
    @$el.find('.spin').length > 0
