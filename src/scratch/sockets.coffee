#!/usr/bin/env coffee
#
# sockets.coffee
#

ipc = require('node-ipc')
{ Connection } = require('./connection')


class Client

  constructor: (@server_id, @id, config) ->
    @connection = null
    @ipc = ipc
    @ipc.config[k] = v for k,v of config
    @ipc.config.id = @id

  connect: =>
    @ipc.connectTo(@server_id, =>
      socket = @ipc.of[@server_id]
      @connection = new Connection(socket))


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



exports.Client = Client    
exports.Server = Server
