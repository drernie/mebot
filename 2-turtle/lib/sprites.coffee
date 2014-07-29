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
    #@current = get()  

  starting_at = (count) -> {x: count % @size, y: Math.floor(count / @size) % @size}

  create_named = (name, count) ->
    start = starting_at(count)
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

  current_turtle = ->
    @current

  set_current_turtle = (turtle) ->
    @current = turtle 

  reset_turtle = ->
    set @current, {x: @current.x0, y: @current.y0}

  location_style = (sprite) ->
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
