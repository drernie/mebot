class @Database
  constructor: (@db) ->
    
  all: ->
    rx.meteor.find @db, {}, {sort:{created:-1}}
  
  destroy: (doc) ->
    @db.remove doc._id
