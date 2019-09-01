#!/usr/bin/env coffee
#
#  faux-ws-client.coffee
#
#  Goal: provide api similar to ws (websockets) but over ipc
#  (e.g. unix sockets)
#
#  Start with the basic client example and massage it into
#  something resembling the ws client.
# 

ipc = require('node-ipc')

class Faux_WS_Client

  constructor: ->
    ipc.config.id = 'hello'
    ipc.config.retry = 1000

  connect: =>
    ipc.connectTo('world', =>
      ipc.of.world.on('connect', @on_Connect)
      ipc.of.world.on('disconnect', @on_Disconnect)
      ipc.of.world.on('app.message', @on_Message)
      console.log(ipc.of.world.destroy))
      
  on_Connect: =>
    ipc.log('## connected to world ##', ipc.config.delay)
    @send('hello')
    
  on_Message: (data) =>
    ipc.log('got a message from world : ', data)

  on_Disconnect: =>
    ipc.log('disconnected from world')

  send: (msg) =>
    ipc.of.world.emit('app.message',
      id: ipc.config.id
      message: msg)


client = new Faux_WS_Client()
client.connect()
