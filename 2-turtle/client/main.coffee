TURTLE_TITLE = "Rohan\'s Reactive Turtles"
CANVAS_SCALE = 100
CANVAS_SIZE = 6

clear_commands = ->
  old_commands = CommandsDB.find()
  old_commands.forEach (command) ->
    console.log(command)
    CommandsDB.remove command._id
  
input_turtle = ->
  input {
    id: 'new-turtle-name'
    type: 'text'
    placeholder: 'Name a new turtle'
    autofocus: true
    keydown: (e) ->
      if e.which == 13
        Sprite.create_named(@val())
        @val('')
        false # In IE, don't set focus on the button(crazy!)
        # <http://stackoverflow.com/questions/12325066/button-click-event-fires-when-pressing-enter-key-in-different-input-no-forms>
  }

nav_action = (dir, arrow, delta) ->
  button {
    style: {font_size: 24}
    class: "submit-btn dir #{Object.keys(delta)} #{dir}"
    title: dir
    click: ->
      turtle = current_turtle()
      Sprite.add turtle, delta
  }, arrow
  
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
  window.commands = Command.all()
  window.sprites = Sprite.all()
  
  $ ->
    document.title = TURTLE_TITLE
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
          console.log("sprite #{sprite}")
          li [
            button {class: 'destroy', click: -> Sprite.destroy sprite}, "X"
            span {
              title: Sprite.location_style(sprite)
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
            width: CANVAS_SIZE * CANVAS_SCALE
            height: CANVAS_SIZE * CANVAS_SCALE
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
