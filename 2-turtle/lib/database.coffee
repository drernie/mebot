class @Database
  constructor: (@db) ->
    
  all: ->
    rx.meteor.find @db, {}, {sort:{created:-1}}

  create: (dict)->
    @db.insert dict

  set: (doc, dict) ->
    @db.update doc._id, {$set: dict}

  get: (dict={}) ->
    proxy = rx.meteor.findOne @db, dict, {sort:{created:-1}}
    proxy.x
  
  destroy: (doc) ->
    @db.remove doc._id
