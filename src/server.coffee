lockeApi = require 'locke-api'
rpcserver = require 'jsonrpc-http-server'
jsonrpc = require 'jsonrpc-http'
store = require 'locke-store-mongo'

exports.construct = ({ port, hashRounds, emailClient }) ->

  blacklistedPasswords = ['hejsan', 'abc123']

  db = store.factory({
    connstr: 'localhost/locke'
  })

  sdb = lockeApi.secure(db, hashRounds)

  api = lockeApi.constructApi({
    db: sdb
    emailClient: emailClient
    blacklistedPassword: blacklistedPasswords
  })

  rpcserver.run({
    api: api
    port: port
    jsonrpc: jsonrpc.construct()
    endpoint: '/'
  })

  # Return some references for the tests
  { db: db }
