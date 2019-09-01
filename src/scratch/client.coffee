#!/usr/bin/env coffee
#
# client.coffee
#

ipc = require('node-ipc')
{ Connection } = require('./connection')


class Client

  constructor: (@server_id, @id) ->
    @connection = null
    @ipc = ipc
    for k,v of config
      @ipc.config[k] = v
    @ipc.config.id = @id

  connect: =>
    @ipc.connectTo(@server_id, =>
      socket = @ipc.of[@server_id]
      @connection = new Connection(socket))


if module.parent
  exports.Client = Client

else
  client = new Client()
  client.connect()
