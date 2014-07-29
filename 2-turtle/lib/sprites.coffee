# https://gist.github.com/michiel/5240409
randomHexColor = (len=3)->                                                                                                                             
  pattern = '0123456789ABCDEF'.split ''                                                                                                                
  str     = '#'                                                                                                                                        
  for i in [1..len]                                                                                                                                    
    str += pattern[Math.floor(Math.random() * pattern.length)]                                                                                         
  str           
    
class @Sprites extends Database
  constructor: (@db, @size, @scale) ->
    super(@db)

  starting_points: ->
    count = @db.length
    {
      x: count % @size
      y: Math.floor(count / @size) % @size
    }

  create_named: (name) ->
    start = starting_points
    @current = create
      title: name.trim()
      x0: start.x
      y0: start.y
      x: start.x 
      y: start.y
      facing: 0
      url: 'images/turtle.png'
      color: randomHexColor()
      created: new Date  

  active: ->
    @current ||= @get()

  is_active: (turtle) ->
    @current == turtle

  set_active: (turtle) ->
    @current = turtle 

  reset_active: ->
    set @current, {x: @current.x0, y: @current.y0}

  move_active: (delta) ->
    Sprite.add @current, delta
    
  canvas_style: ->
    width: @size * @scale
    height: @size * @scale

  location_style: (sprite) ->
    "
      position: absolute;
      border: 0;
      top: #{(0.5 + sprite.y) * @scale}px;
      left: #{(1.5 + sprite.x) * @scale}px;
      width: #{@scale}px;
      height: #{@scale}px;
      background-color: #{if @current == sprite then sprite.color else '#FFF'};
      -webkit-transform: rotate(#{90*sprite.facing}deg);
    "
    
  add_command: (delta) ->
    "noop"

#      CommandsDB.insert {title: turtle.title, move: delta, pos: {x: turtle.x, y: turtle.y, facing: turtle.facing}}
