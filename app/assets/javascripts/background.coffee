paper.install(@)

radToDeg = (radians)->
    (radians * 180 / Math.PI)

Background = Backbone.View.extend
  events:
    'mousemove': 'setAngle'

  distance: 35

  style: 
    strokeWidth : 15
    strokeColor : '#f3f3f4'
    strokeCap   : 'square'
    strokeJoin  : 'miter'
    

  initialize: ->
    @width  = $(window).width()
    @height = $(window).height()
    # Setup
    @$el.height $(window).height()
    # Setup Paper.js
    paper.setup(@el)

    @pattern = new Group()

    steps = Math.ceil(Math.max(@width, @height) / @distance)

    for y in [0..steps]
      segments = []
      segments.push new Point(20, y * @distance + @distance / 2)
      for x in [0..steps]
        point = segments[x].clone()
        point.x += @distance
        point.y += @distance * (if x % 2 then 1 else -1)
        segments.push(point)

      path = new Path(segments)
      path.position.x -= @width / 2
      path.style = @style

      @pattern.addChild(path)

    # Compass
    @compass = new Path()
    @compass.strokeColor = 'red'
    @compass.strokeWidth = 3

    @compass.add([view.center.x, view.center.y])
    @compass.add([view.center.x + 50, view.center.y])

    view.draw()
    view.onFrame = _.bind @render, @

  setAngle: (event)->
    boxCenterX = view.center.x
    boxCenterY = view.center.y
    # Calulate the triangle dimensions
    x = boxCenterX - event.pageX
    y = boxCenterY - event.pageY
    # Find the angle in radians
    radians = Math.atan(y / x)
    # Correct the angle by quadrant
    if event.pageX > boxCenterX && event.pageY < boxCenterY then radians += Math.PI / 2;
    if event.pageX > boxCenterX && event.pageY > boxCenterY then radians += Math.PI / 2;
    if event.pageX < boxCenterX && event.pageY > boxCenterY then radians += Math.PI * 1.5;
    if event.pageX < boxCenterX && event.pageY < boxCenterY then radians += Math.PI * 1.5;
    # if event.pageX > boxCenterX && boxCenterY < event.pageY then radians -= 2 * Math.PI
    
    # Convert the angles to degress without significance
    @angle = radToDeg(radians).toFixed(0)
    console.log "#{@angle}º"

  render: ->
    # @delta = ((@angle || 0) - (@currentAngle || 0)) / 5
    # @currentAngle ||= 0
    # @currentAngle  += @delta
    # @pattern.rotate(@delta, view.center)

app.register('views.Background', Background)