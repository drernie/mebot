# https://gist.github.com/michiel/5240409
randomHexColor = (len=3)->                                                                                                                             
  pattern = '0123456789ABCDEF'.split ''                                                                                                                
  str     = '#'                                                                                                                                        
  for i in [1..len]                                                                                                                                    
    str += pattern[Math.floor(Math.random() * pattern.length)]                                                                                         
  str           
    
class @SpriteClass extends Database
  constructor: (@db, @size, @scale) ->
    super(@db)

  starting_points: ->
    count = @db.length
    {
      x: count % @size
      y: Math.floor(count / @size) % @size
    }

  create_named: (name) ->
    start = @starting_points()
    @create
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
    @get {isCurrent: true} || @get()

  is_active: (turtle) ->
    turtle.title == @active().title

  clear_active: ->
    @set @active, {isCurrent: false}

  set_active: (turtle) ->
    @clear_active()
    @set turtle, {isCurrent: true}

  reset_active: ->
    current = @active
    @set current, {x: current.x0, y: current.y0}

  move_active: (delta) ->
    @add @active, delta
    
  canvas_style: ->
    width: @size * @scale
    height: @size * @scale

  location_style: (sprite) =>
    "
      position: absolute;
      border: 0;
      top: #{(0.5 + sprite.y) * @scale}px;
      left: #{(1.5 + sprite.x) * @scale}px;
      width: #{@scale}px;
      height: #{@scale}px;
      background-color: #{if @is_active(sprite) then sprite.color else '#FFF'};
      -webkit-transform: rotate(#{90*sprite.facing}deg);
    "
    
  add_command: (delta) ->
    "noop"

#      CommandsDB.insert {title: turtle.title, move: delta, pos: {x: turtle.x, y: turtle.y, facing: turtle.facing}}
