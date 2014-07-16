Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.commands = rx.meteor.find Commands, {}, {sort:{created:-1}}

  $ ->
    document.title = 'Turtle-Viewer'
    $('body').prepend(
      h1 'rohan turtles'
      img {
        style: 'position: absolute; top: 0; left: 0; border: 0; width: 99px; height: 99px; transform: rotate(90deg);'
        src: 'images/turtle.png'
        alt: 'Rohan Turtle'
      }
    )
