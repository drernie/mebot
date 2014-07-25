class @Database
  constructor: (@db) ->
    
  all: ->
    rx.meteor.find @db, {}, {sort:{created:-1}}

  create: (dict)->
    @db.insert dict

  set: (doc, dict) ->
    @db.update doc._id, {$set: dict}
  
  destroy: (doc) ->
    @db.remove doc._id
