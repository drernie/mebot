TURTLE_TITLE = "Rohan\'s Reactive Turtles"
TURTLE_SCALE = 100

create_sprite = (val, count) ->
  index = count % 6 
  SpritesDB.insert
    title: val.trim()
    x: index 
    y: index 
    facing: 0
    url: 'images/turtle.png'
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
  
current_turtle = ->
  proxy = rx.meteor.findOne SpritesDB, {}, {sort:{created:-1}}
  proxy.x._id
    
nav_action = (dir, arrow, delta) ->
  button {
    style: {width: 61}
    class: "submit-btn dir #{Object.keys(delta)} #{dir}"
    title: dir
    click: ->
      SpritesDB.update current_turtle(), {$inc: delta}
  }, arrow

location_style = (sprite) ->
  "
    position: absolute;
    border: 0;
    top: #{sprite.y * TURTLE_SCALE}px;
    left: #{sprite.x * TURTLE_SCALE}px;
    width: #{TURTLE_SCALE}px;
    height: #{TURTLE_SCALE}px;
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
      div {style: "position: absolute"}, [
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
      
        div {
          class: 'canvas'
          style:
            width: 10 * TURTLE_SCALE
            height: 10 * TURTLE_SCALE
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
