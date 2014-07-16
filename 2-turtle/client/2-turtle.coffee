Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.commands = rx.meteor.find Commands, {}, {sort:{created:-1}}
	
  x_value = ->
    5
  y_value = ->
    1
  angle = ->
    1
	
  $ ->
    document.title = 'Turtle-Viewer'
		
    $('body').prepend(
      h1 "Rohan\'s Turtle"
      div {
        class: 'canvas'
        style: "height: 4in; width: 4in;"
      }, [
        img {
          style: "top: #{100*y_value()}px; left: #{100*x_value()}px;
  					 		  -webkit-transform: rotate(#{90*angle()}deg);
  				        position: absolute; border: 0; width: 99px; height: 99px;"
          src: 'images/turtle.png'
          alt: "Rohan\'s Turtle"
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
