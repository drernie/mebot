class Database
  constructor: (@db) ->
  all: ->
    rx.meteor.find @db, {}, {sort:{created:-1}}
    
@CommandsDB = new Meteor.Collection 'commands'
@SpritesDB = new Meteor.Collection 'sprites'
@Sprite = new Database(@SpritesDB)
