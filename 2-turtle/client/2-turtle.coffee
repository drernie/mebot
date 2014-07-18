Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.commands = rx.meteor.find Commands, {}, {sort:{created:-1}}
	
	
  $ ->
    x = rx.cell()
    x.set(5)
    y = rx.cell()
    y.set(3)
    facing = rx.cell()
    facing.set(2)
    document.title = 'Turtle-Viewer'
		
    $('body').prepend(
      h1 "Rohan\'s Turtle"
      h1 "Controls"
      ul {}, [
        li {}, [
          button {
            class: 'submit-btn'
            title: 'North'
            click: ->
              x.set(2)
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
      }, [
        img {
          style: "top: #{100*y.get()}px; left: #{100*x.get()}px;
  					 		  -webkit-transform: rotate(#{90*facing.get()}deg);
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
