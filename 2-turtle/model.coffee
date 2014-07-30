CANVAS_SCALE = 100
current = 6

@SpritesDB = new Meteor.Collection 'sprites'
@Sprites = new SpriteClass(SpritesDB, current, CANVAS_SCALE)

@CommandsDB = new Meteor.Collection 'commands'
@Command = new Database(CommandsDB)
