Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.tasks = rx.meteor.find Commands, {}, {sort:{created:-1}}
  window.taskLast = rx.meteor.findOne Commands, {}, {sort:{created:-1}}

  $ ->
    document.title = 'Turtle Viewer'
    $('body').prepend(
      img {
        style: 'position: absolute; top: 0; left: 0; border: 0; width: 99px; height: 99px; transform: rotate(90deg);'
        src: 'images/turtle.png'
        alt: 'Rohan Turtle'
      }
    )
