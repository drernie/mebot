TURTLE_TITLE = "Rohan\'s Turtle"
  
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
            SpritesDB.insert
              title: @val().trim()
              x: 1
              y: 2
              facing: 0
              url: 'images/turtle.png'
              created: new Date
            @val('')
            false # In IE, don't set focus on the utton(crazy!)
            # <http://stackoverflow.com/questions/12325066/button-click-event-fires-when-pressing-enter-key-in-different-input-no-forms>
      }
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
          span "(#{x.get()}, #{y.get()}) -> #{facing.get()}"
          button {class: 'submit-btn', title: 'East'}, ['►']
        ]
        li {}, [
          button {class: 'submit-btn', title: 'South'}, ['⬇']
        ]
      ]
      div {
        class: 'canvas'
        style: "height: 4in; width: 4in;"
      }, sprites.all().map (sprite) ->
        img {
          rotation_style: "-webkit-transform: rotate(#{90*sprite.facing}deg);"
          style:
            top: 10*sprite.y
            left: 10*sprite.x
  				  position: 'absolute'
            border: 0
            width: 10
            height: 10
          src: sprite.url
          alt: sprite.title
        }
      ]
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
