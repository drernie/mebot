class @Database
  constructor: (@db) ->
    
  find: (query={}) ->
    proxy = rx.meteor.find @db, query, {sort:{created:-1}}
    proxy

  create: (dict)->
    @db.insert dict

  get: (query={}) ->
    proxy = rx.meteor.findOne @db, query, {sort:{created:-1}}
    proxy.x

  set: (doc, dict) ->
    @db.update doc._id, {$set: dict}

  add: (doc, dict) ->
    @db.update doc._id, {$inc: dict}
  
  destroy: (doc) ->
    @db.remove doc._id
