({sprites}) ->
  heading: "Rock-N-Roll Turtles"
  subheading: "Page 1"
  contents:
    Controls: [
      'North'
      ['West','East']
      'South'
    ]
    Roster: sprites.map (sprite) ->
      destroy_button: "X"
      sprite_listing: {title, x, y, facing, color, isCurrent} = sprite
