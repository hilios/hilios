Posts = Backbone.View.extend
  events:
    'inview li:last': 'paginate'

  initialize: ->
    @page  = parseInt @$el.data('page') || 0
    @total = parseInt @$el.data('total')
    @total = Math.ceil @total / 20
    @$spin = $('<li class="spin" />')

  paginate: (event, isInView, visiblePartX, visiblePartY)->
    if not @hasSpin() and not @allLoaded()
      @page++
      # Set the spinner
      @$spin.appendTo(@el)
      @$spin.spin('large')
      # Fetch resuts
      $.get('/', page: @page).done(_.bind @render, @)

  hasSpin: ->
    @$el.has(@$spin).length > 0

  allLoaded: ->
    @page >= @total

  render: (data, textStatus)->
    return @fail.apply(@, arguments) if textStatus is not 'success'
    # Remove spin and append result
    @$spin.detach()
    @$el.append(data)

  fail: ->
    console.log 'Failed!'
    
# Register this view
app.register('views.Posts', Posts)