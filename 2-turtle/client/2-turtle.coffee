TURTLE_TITLE = "Rohan\'s Turtle"
TURTLE_SCALE = 100


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
  
create_sprite = (val, count) ->
  index = count % 6 
  SpritesDB.insert
    title: val.trim()
    x: index 
    y: index 
    facing: 0
    url: 'images/turtle.png'
    created: new Date
    
nav_updown = (dir, arrow) ->
  button {
    style: {width: 61}
    class: "submit-btn dir vertical #{dir}"
    title: dir
    click: ->
      if (dir == 'North') then turtle.y++ else turtle.y--
  }, arrow

nav_sides = (dir, arrow) ->
  button {
    class: "submit-btn dir horizontal #{dir}"
    title: dir
    click: ->
      if (dir == 'East') then turtle.x++ else turtle.x--
  }, arrow

Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.commands = rx.meteor.find CommandsDB, {}, {sort:{created:-1}}
  window.sprites = rx.meteor.find SpritesDB, {}, {sort:{created:-1}}
  window.turtle = rx.meteor.findOne SpritesDB, {}, {sort:{created:-1}}
	
  $ ->
    document.title = 'Turtle-Viewer'
		
    $('body').prepend(
      h1 TURTLE_TITLE
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
      h1 "Controls"
      ul {}, [
        li {}, [
          nav_updown('North', '⬆')
        ]
        li {}, [
          button {class: 'submit-btn dir', title: 'West'}, ['◀︎']
          button {class: 'submit-btn dir', title: 'East'}, ['►']
        ]
        li {}, [
          nav_updown('South', '⬇')
        ]
      ]
      h1 "Roster"
      ul {}, sprites.map (sprite) ->
        li {}, [
          button {class: 'destroy', click: -> SpritesDB.remove sprite._id}, "X"
          span {title: location_style(sprite)}, sprite.title
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
          alt: sprite.title
        }
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
    )
