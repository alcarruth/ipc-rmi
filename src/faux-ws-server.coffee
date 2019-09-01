#!/usr/bin/env coffee
#
#  faux-ws-server.coffee
#
#  Goal: provide api similar to ws (websockets) but over ipc
#  (e.g. unix sockets)
#
#  Start with the basic server example and massage it into
#  something resembling the ws server.
#
#  These are the events that we require for RMI_Connection
# 
#    ws.onopen
#    ws.onmessage
#    ws.onclose
#    ws.onerror
#
#  From the node-ipc docs these are the node-ipc events
#
#   error
#   connect
#   disconnect - triggered by client
#   socket.disconnected - triggered by server
#   destroy
#   data
#   [your event type]- triggered when a JSON message is received
#
#  Seems like two ways to go here:
#
#   1. Define new events at the node-ipc level.
#
#     event_Map = {
#       open: 'connect'
#       close: 'disconnect'
#       message: 'data'
#       error: 'error'
#     }
#  
#   2. create a new event emitter and use it for the faux ws events.

ipc = require('node-ipc')

class RMI_Server
  
  constructor: ->
    ipc.config.id = 'rmi-server'
    ipc.config.retry= 1500

  on_Message: (data, socket) =>
    @send(socket, data.message+' world!')

  # TODO: is this meaningful for the server?
  # the following came from client
  # 
  on_Connect: =>
    ipc.log('## connected to world ##', ipc.config.delay)
    @send('hello')

  # TODO: again, this is from client.  We'll need a per
  # client disconnect handler
  # 
  on_Disconnect: =>
    ipc.log('disconnected from world')

  send: (socket, msg) =>
    ipc.server.emit(socket, 'app.message',
      id: ipc.config.id
      message: msg)

  start: =>
    ipc.serve =>
      ipc.of.world.on('error', @on_Error)
      ipc.of.world.on('connect', @on_Connect)
      ipc.of.world.on('disconnect', @on_Disconnect)
      ipc.server.on('app.message', @on_Message)
    ipc.server.start()


server = new Faux_WS_Server()
server.start()
