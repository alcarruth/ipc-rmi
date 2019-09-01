#!/usr/bin/env coffee
#
# server.coffee
#

ipc = require('node-ipc')
{ Connection } = require('./connection')


class Server

  constructor: (@id, config) ->
    @config = config || {}
    @connections = []
    @ipc = ipc
    @ipc.config[k] = v for k,v of config
    @ipc.config.id = @id

  start: =>  
    @ipc.serve =>
      @ipc.server.on('connect', @on_Connect)
    @ipc.server.start()

  on_Connect: (socket) =>
    connection = new Connection(socket, @ipc.server)
    @connections.push(connection)


if module.parent
  exports.Server = Server

else
  server = new Server()
  server.start()
  
  
