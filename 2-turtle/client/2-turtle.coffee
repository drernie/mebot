TURTLE_TITLE = "Rohan\'s Turtle"
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
    
nav_updown = (dir, arrow, callback) ->
  button {
    style: {width: 61}
    class: "submit-btn dir vertical #{dir}"
    title: dir
    click: callback
  }, arrow

nav_sides = (dir, arrow) ->
  button {
    class: "submit-btn dir horizontal #{dir}"
    title: dir
    click: ->
      proxy = rx.meteor.findOne SpritesDB, {}, {sort:{created:-1}}
      if proxy?
        turtle = proxy.x
        offset = if (dir == 'East') then +1 else -1
        SpritesDB.update turtle ._id, {$inc: {x: offset}}
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
  window.proxy = rx.meteor.findOne SpritesDB, {}, {sort:{created:-1}}
  
  $ ->
    document.title = 'Turtle-Viewer'
    $('body').prepend(
      h1 TURTLE_TITLE
      input_turtle()
      
      h1 "Roster"
      ul sprites.map (sprite) ->
        li [
          button {class: 'destroy', click: -> SpritesDB.remove sprite._id}, "X"
          span {title: location_style(sprite)}, sprite.title
        ]
      
      h1 "Controls"
      if proxy?
        h2 proxy.x.title
        ul [
          li nav_updown 'North', '⬆', -> proxy.x.y++
          li [
            nav_sides 'West', '◀︎'
            nav_sides 'East', '►'
          ]
          li nav_updown 'South', '⬇', => proxy.x.y--
        ]
      
      h1 "Canvas"
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
    )
