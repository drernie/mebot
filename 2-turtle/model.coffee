@SpritesDB = new Meteor.Collection 'sprites'
@Sprite = new Database(SpritesDB)

@CommandsDB = new Meteor.Collection 'commands'
@Command = new Database(CommandsDB)
