class @Database
  constructor: (@db) ->
    
  all: ->
    proxy = rx.meteor.find @db, {}, {sort:{created:-1}}
    proxy

  create: (dict)->
    @db.insert dict

  get: (dict={}) ->
    #proxy = rx.meteor.findOne @db, dict, {sort:{created:-1}}
    #proxy.x
    items = @all().xs
    n = items.length
    items[n-1]

  set: (doc, dict) ->
    @db.update doc._id, {$set: dict}

  add: (doc, dict) ->
    @db.update doc._id, {$inc: dict}
  
  destroy: (doc) ->
    @db.remove doc._id
