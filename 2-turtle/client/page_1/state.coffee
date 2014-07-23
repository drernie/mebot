({sprites}) ->
  title: "Rock-N-Roll Turtles"
  subtitle: "Page 1"
  contents:
    controls: [
      'North'
      ['West','East']
      'South'
    ]
    roster: sprites.map (sprite) ->
      destroy_button: "X"
      sprite: {title, x, y, facing, color, isCurrent} = sprite
