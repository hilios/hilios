app.views.posts = Backbone.View.extend
  page: 0

  events:
    'inview': 'paginate'

  paginate: (event, isInView, visiblePartX, visiblePartY)->
    if visiblePartY is 'bottom'
    $target = $(event.target)
    $spin   = $target.find('.spin')
    if not $spin.length
      $spin = $('<div class="spin"></div>')
      $spin.appendTo(event.target)
      $spin.spin('large')