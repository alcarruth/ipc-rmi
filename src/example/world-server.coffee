#!/usr/bin/env coffee
#
# world-server.coffee
#
# coffeescript version of node-ipc basic example server
# 

ipc = require('node-ipc')

# You should start both hello and world
# then you will see them communicating.

class World_Server

  constructor: ->
    @ipc = ipc
    @ipc.config.id = 'world'
    @ipc.config.retry= 1500

  start: =>
    @ipc.serve =>
      @ipc.server.on('app.message', @on_Message)
      @ipc.server.on('connect', @on_Connect)
      @ipc.server.on('disconnect', @on_Disconnect)
    @ipc.server.start()

  on_Connect: =>
    @ipc.log('connect from: ???')

  on_Disconnect: =>
    @ipc.log('??? disconnected')
    
  on_Message: (data, socket) =>
    @ipc.log("socket: #{socket}")
    @ipc.log(data)

  send: (socket, msg) =>
    @ipc.server.emit(socket, 'app.message',
      id: @ipc.config.id
      message: msg)
    

if module.parent
  exports.World_Server = World_Server

else
  server = new World_Server()
  server.start()
  
  
