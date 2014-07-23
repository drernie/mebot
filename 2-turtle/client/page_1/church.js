// Generated by CoffeeScript 1.7.1
({
  Roster: {
    sprite: function(_arg) {
      var TURTLE_SCALE, color, facing, isCurrent, style, title, x, y;
      title = _arg.title, x = _arg.x, y = _arg.y, facing = _arg.facing, color = _arg.color, isCurrent = _arg.isCurrent;
      TURTLE_SCALE = 100;
      style = "position: absolute; border: 0; top: " + ((0.5 + y) * TURTLE_SCALE) + "px; left: " + ((1.5 + x) * TURTLE_SCALE) + "px; width: " + TURTLE_SCALE + "px; height: " + TURTLE_SCALE + "px; background-color: " + (isCurrent ? color : '#FFF') + "; -webkit-transform: rotate(" + (90 * facing) + "deg);";
      return span({
        title: style,
        style: {
          color: color,
          font_weight: isCurrent ? 'bold' : void 0
        }
      }, title);
    }
  }
});
