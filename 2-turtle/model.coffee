CANVAS_SCALE = 100
CANVAS_SIZE = 6

@SpritesDB = new Meteor.Collection 'sprites'
@Sprite = new Sprites(SpritesDB, CANVAS_SIZE, CANVAS_SCALE)

@CommandsDB = new Meteor.Collection 'commands'
@Command = new Database(CommandsDB)
