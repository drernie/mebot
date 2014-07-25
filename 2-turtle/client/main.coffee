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
  Sprite.get {isCurrent: true}
  
clear_commands = ->
  old_commands = CommandsDB.find()
  old_commands.forEach (command) ->
    console.log(command)
    CommandsDB.remove command._id

clear_current_turtle = ->
  clear_commands()
  turtle = current_turtle()
  SpritesDB.update turtle._id, {$set: {isCurrent: false}}

set_current_turtle = (turtle) ->
  clear_current_turtle()
  Sprite.set(turtle, {isCurrent: true})

starting_at = (count) ->
  {
    x: count % CANVAS_SIZE 
    y: Math.floor(count / CANVAS_SIZE) % CANVAS_SIZE
  }

create_sprite = (val, count) ->
  start = starting_at(count)
  clear_current_turtle()
  SpritesDB.insert
    title: val.trim()
    x0: start.x
    y0: start.y
    x: start.x 
    y: start.y
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


reset_turtle = ->
      turtle = current_turtle()
      SpritesDB.update turtle._id, {$set: {x: turtle.x0, y: turtle.y0}}

nav_action = (dir, arrow, delta) ->
  button {
    style: {font_size: 24}
    class: "submit-btn dir #{Object.keys(delta)} #{dir}"
    title: dir
    click: ->
      turtle = current_turtle()
      SpritesDB.update turtle._id, {$inc: delta}
      turtle = current_turtle()
      CommandsDB.insert {title: turtle.title, move: delta, pos: {x: turtle.x, y: turtle.y, facing: turtle.facing}}
  }, arrow

location_style = (sprite) ->
  "
    position: absolute;
    border: 0;
    top: #{(0.5 + sprite.y) * TURTLE_SCALE}px;
    left: #{(1.5 + sprite.x) * TURTLE_SCALE}px;
    width: #{TURTLE_SCALE}px;
    height: #{TURTLE_SCALE}px;
    background-color: #{if sprite.isCurrent then sprite.color else '#FFF'};
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
  window.sprites = @Sprite.all()
  
  $ ->
    document.title = 'Turtle-Viewer'
    $('body').prepend(
      div {style: "position: absolute; top: 0; left: 0; margin-left: 1em;"}, [
        h1 TURTLE_TITLE
      
        h2 "Controls"
        table [
          tr [
            td ""
            td nav_action 'North', '▲', {y: -1}
            td ""
          ]
          tr [
            td nav_action 'West', '◀︎', {x: -1}
            td nav_action 'Turn', '⟳', {facing: 1}
            td nav_action 'East', '►', {x: 1}
          ]
          tr [
            td ""
            td nav_action 'South', '▼', {y: 1}
            td ""
          ]
        ]
      
        h2 "Roster"
        ul sprites.map (sprite) ->
          li [
            button {class: 'destroy', click: -> Sprite.destroy doc}, "X"
            span {
              title: location_style(sprite)
              style:
                color: sprite.color
                font_weight: 'bold' if sprite.isCurrent
            }, sprite.title
          ]
        p input_turtle()

        h2 "Commands"
        span [
          button {
            class: 'commands clear'
            click: -> clear_commands()
          }, "Clear"
          button {
            class: 'commands clear'
            click: -> clear_commands()
          }, "Reset"
          p "Return"
          p ""
          p "Step"
        ] 
        ul commands.map (command) ->
          li [
            button {class: 'destroy', click: -> CommandsDB.remove command._id}, "X"
            span "#{command.title}: #{JSON.stringify(command.move)} @ #{JSON.stringify(command.pos)}"
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
            click: ->
              set_current_turtle(sprite)
          }
        footer()
      ]
    )
