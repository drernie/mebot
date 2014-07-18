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
      h1 "Roster"
      ul {}, sprites.map (sprite) ->
        li {}, [
          button {
            class: 'destroy'
            click: -> SpritesDB.remove sprite._id
          }, "X"
          span {title: location_style(sprite)}, sprite.title
      ]
      h1 "Controls"
      ul {}, [
        li {}, [
          button {
            class: 'submit-btn'
            title: 'North'
            click: ->
              turtle.x = 5
          }, ['⬆']
        ]
        li {}, [
          button {class: 'submit-btn', title: 'West'}, ['◀︎']
          button {class: 'submit-btn', title: 'East'}, ['►']
        ]
        li {}, [
          button {class: 'submit-btn', title: 'South'}, ['⬇']
        ]
      ]
      h1 "Canvas"
      div {
        class: 'canvas'
        style:
          width: 10 * TURTLE_SCALE
          height: 10 * TURTLE_SCALE
      }, sprites.map (sprite) ->
        img {
          rotation_style: "-webkit-transform: rotate(#{90*sprite.facing}deg);"
          style: location_style(sprite)
          src: sprite.url
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
