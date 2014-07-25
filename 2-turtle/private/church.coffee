@page_1_church = ->
  Roster:
    sprite_listing: ({title, x, y, facing, color, isCurrent}) ->
      TURTLE_SCALE = 100
      style = "
        position: absolute;
        border: 0;
        top: #{(0.5 + y) * TURTLE_SCALE}px;
        left: #{(1.5 + x) * TURTLE_SCALE}px;
        width: #{TURTLE_SCALE}px;
        height: #{TURTLE_SCALE}px;
        background-color: #{if isCurrent then color else '#FFF'};
        -webkit-transform: rotate(#{90*facing}deg);
      "
      span {
        title: style
        style:
          color: color
          font_weight: 'bold' if isCurrent
      }, title
