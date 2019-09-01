#!/usr/bin/env coffee
#
#  hello-client.coffee
#
#  An object-oriented coffeescript version of node-ipc basic example client
# 

ipc = require('node-ipc')

# You should start both hello and world
# then you will see them communicating.

class Client

  constructor: (@server) ->
    @ipc = ipc
    @ipc.config.id = 'hello'
    @ipc.config.retry = 1000

  connect: =>
    @ipc.connectTo(@server, =>
      @ipc.of.world.on('connect', @on_Connect)
      @ipc.of.world.on('disconnect', @on_Disconnect)
      @ipc.of.world.on('app.message', @on_Message)
      console.log(@ipc.of[@server].destroy))
      
  on_Connect: (args...) =>
    @ipc.log(args)
    @ipc.log('## connected to world ##', @ipc.config.delay)
    
  on_Disconnect: =>
    @ipc.log('disconnected from world')

  on_Message: (data, socket) =>
    @ipc.log("socket: #{socket}")
    @ipc.log(data)

  send: (data) =>
    @ipc.of[@server].emit('app.message',
      id: @ipc.config.id
      message: data)


if module.parent
  exports.Hello_Client = Hello_Client

else
  client = new Hello_Client()
  client.connect()
