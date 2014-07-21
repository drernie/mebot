TURTLE_TITLE = "Rohan\'s Reactive Turtles"
TURTLE_SCALE = 100
CANVAS_SIZE = 6

# https://gist.github.com/michiel/5240409
randomHexColor = (len=3)->                                                                                                                             
  pattern = '0123456789ABCDEF'.split ''                                                                                                                
  str     = '#'                                                                                                                                        
  for i in [1..len]                                                                                                                                    
    str += pattern[Math.floor(Math.random() * pattern.length)]                                                                                         
  str           

current_turtle = ->
  proxy = rx.meteor.findOne SpritesDB, {isCurrent: true}, {sort:{created:-1}}
  proxy.x

clear_current_turtle = ->
  current = current_turtle()
  SpritesDB.update current._id, {$set: {isCurrent: false}}
   
create_sprite = (val, count) ->
  clear_current_turtle()
  index =    
  SpritesDB.insert
    title: val.trim()
    x: count % CANVAS_SIZE 
    y: Math.floor(count / CANVAS_SIZE) % CANVAS_SIZE
    facing: 0
    url: 'images/turtle.png'
    color: randomHexColor()
    isCurrent: true
    created: new Date  
  
input_turtle = ->
  input {
    id: 'new-turtle-name'
    type: 'text'
    placeholder: 'Name a new turtle'
    autofocus: true
    keydown: (e) ->
      if e.which == 13
        create_sprite(@val(), sprites.length())
        @val('')
        false # In IE, don't set focus on the button(crazy!)
        # <http://stackoverflow.com/questions/12325066/button-click-event-fires-when-pressing-enter-key-in-different-input-no-forms>
  }
    
nav_action = (dir, arrow, delta) ->
  button {
    style: {width: 61} if delta.y?
    class: "submit-btn dir #{Object.keys(delta)} #{dir}"
    title: dir
    click: ->
      turtle = current_turtle()
      SpritesDB.update turtle._id, {$inc: delta}
      CommandsDB.insert {title: turtle.title, move: delta}
  }, arrow

location_style = (sprite) ->
  "
    position: absolute;
    border: 0;
    top: #{(0.5 + sprite.y) * TURTLE_SCALE}px;
    left: #{(1.5 + sprite.x) * TURTLE_SCALE}px;
    width: #{TURTLE_SCALE}px;
    height: #{TURTLE_SCALE}px;
    background-color: #{sprite.color};
    -webkit-transform: rotate(#{90*sprite.facing}deg);
  "
  
footer = ->
  div {
    id: 'page-footer'
    style: 'margin-top: 100px; text-align:center; text-shadow: white 0.1em 0.1em 0.1em;'
  }, [
    span 'Proudly built with '
    span {
      style: 'cursor: pointer; cursor: hand;'
      click: ->
        window.open 'https://github.com/zhouzhuojie/meteor-reactive-coffee'
    }, 'Meteor-Reactive-Coffee'
  ]
  
Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.commands = rx.meteor.find CommandsDB, {}, {sort:{created:-1}}
  window.sprites = rx.meteor.find SpritesDB, {}, {sort:{created:-1}}
  
  $ ->
    document.title = 'Turtle-Viewer'
    $('body').prepend(
      div {style: "position: absolute; top: 0; left: 0; margin-left: 1em;"}, [
        h1 TURTLE_TITLE
      
        h2 "Controls"
        ul [
          li nav_action 'North', '⬆', {y: -1}
          li [
            nav_action 'West', '◀︎', {x: -1}
            nav_action 'East', '►', {x: 1}
          ]
          li nav_action 'South', '⬇', {y: 1}
        ]
      
        h2 "Roster"
        ul sprites.map (sprite) ->
          li [
            button {class: 'destroy', click: -> SpritesDB.remove sprite._id}, "X"
            span {title: location_style(sprite)}, sprite.title
          ]
        p input_turtle()

        h2 "Commands"
        h3 commands.length
        ul commands.map (command) ->
          li [
            button {class: 'destroy', click: -> CommandsDB.remove command._id}, "X"
            span "#{command.title}: #{Object.keys command.move} #{command.move.x || command.move.y}"
          ]
      
        div {
          class: 'canvas'
          style:
            width: CANVAS_SIZE * TURTLE_SCALE
            height: CANVAS_SIZE * TURTLE_SCALE
        }, sprites.map (sprite) ->
          img {
            style: location_style(sprite)
            src: sprite.url
            title: sprite.title
            alt: "#{sprite.title}'s Turtle"
          }
        footer()
      ]
    )
