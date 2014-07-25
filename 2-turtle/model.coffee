@CommandsDB = new Meteor.Collection 'commands'
@SpritesDB = new Meteor.Collection 'sprites'
@Sprite = new Database(@SpritesDB)
@Command = new Database(@CommandsDB)
