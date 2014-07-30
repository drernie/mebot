TURTLE_TITLE = "Teenage Robot Turtles"

clear_commands = ->
  old_commands = CommandsDB.find()
  old_commands.forEach (command) ->
    console.log(command)
    CommandsDB.remove command._id
  
turtle_input_field = ->
  input {
    id: 'new-turtle-name'
    type: 'text'
    placeholder: 'Name a new turtle'
    autofocus: true
    keydown: (e) ->
      if e.which == 13
        Sprites.create_named(@val())
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
      Sprites.move_active(delta)
  }, arrow
  
controls = ->
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
  window.commands = Command.find()
  window.sprites = Sprites.find()
  
  $ ->
    document.title = TURTLE_TITLE
    $('body').prepend(
      div {style: "position: absolute; top: 0; left: 0; margin-left: 1em;"}, [
        h1 TURTLE_TITLE
      
        h2 "Controls"
        controls()
      
        h2 "Roster"
        div bind -> [
          p "active: #{Sprites.active().title}"
          ul sprites.all().map (sprite) ->
            li [
              button {class: 'destroy', click: -> Sprites.destroy sprite}, "X"
              span {
                title: Sprites.location_style(sprite)
                style:
                  color: sprite.color
                  font_weight: 'bold' if Sprites.is_active(sprite)
              }, sprite.title
              span " #{Sprites.is_active(sprite)}"
            ]
        ]
        p turtle_input_field()

        h2 "Commands"
        span [
          button {
            class: 'commands clear'
            click: -> clear_commands()
          }, "Clear"
          button {
            class: 'commands reset'
            click: -> Sprites.reset_active()
          }, "Reset"
        ] 
        ul commands.map (command) ->
          li [
            button {class: 'destroy', click: -> CommandsDB.remove command._id}, "X"
            span "#{command.title}: #{JSON.stringify(command.move)} @ #{JSON.stringify(command.pos)}"
          ]
      
        div bind ->
          div {
            class: 'canvas'
            style: Sprites.canvas_style()
          }, sprites.all().map (sprite) ->
            img {
              style: Sprites.location_style(sprite)
              src: sprite.url
              title: sprite.title
              alt: "#{sprite.title}'s Turtle"
              click: -> Sprites.set_active(sprite)
            }
        footer()
      ]
    )
