request = require 'request'
_ = require 'underscore'
steps = require './acceptance-std/steps'
server = require '../src/server'





port = 6060

emailClient = do ->
  lastEmail = null

  send: (to, data, callback) ->
    content = data.app + " " + to + " " + data.token
    lastEmail = { to: to,  content: content }
    callback(null)

  getLastEmail: (callback) ->
    callback null, lastEmail

refs = server.construct({ port: port, hashRounds: 1, emailClient: emailClient, mongo: 'localhost/locke' })



locke = (func, args, callback) ->
  request
    url: "http://localhost:#{port}/"
    method: 'POST'
    json:
      params: args
      method: func
      jsonrpc: '2.0'
      id: 'id'
  , (err, res, body) ->
    if body.error?
      callback(null, { status: body.error.data ? 'WAT' })
    else
      callback(null, _.extend({}, body.result, { status: 'OK' }))



module.exports = steps.factory(locke, emailClient.getLastEmail, refs.db.clean)
