#!/usr/bin/env coffee
#
#  faux-ws.coffee
#

{ IPC } = require('node-ipc')
{ EventEmitter } = require('events')
{ Connection } = require('../../ws-rmi/src')


random_id = (name) ->
  "#{name}_#{Math.random().toString()[2..]}"


# Connnection must be a sub-class of RMI_Connection in order to
# create and register desired RMI_Objects at construction.
#
class Faux_WS extends EventEmitter

  constructor: (@socket, @server) ->
    super()
    @id = random_id('faux-ws')
    if @server
      @server.on('connect', @on_Connect)
      @server.on('disconnect', @on_Disconnect)
      @server.on('app.message', @on_Message)
      @server.on('error', @on_Error)

      @socket.on('connect', @on_Connect)
      @socket.on('disconnect', @on_Disconnect)
      @socket.on('app.message', @on_Message)
      @socket.on('error', @on_Error)
    else
      @socket.on('connect', @on_Connect)
      @socket.on('disconnect', @on_Disconnect)
      @socket.on('app.message', @on_Message)
      @socket.on('error', @on_Error)
    #console.log(socket.destroy))

  # TODO:
  # 
  # The websocket api has two events 'connection' and 'open'.  The
  # node-ipc api has only a 'connect' method.  Ideally I'd like, in
  # this code, to map the node-ipc events to websocket events so that
  # faux-ws can serve as a drop-in replacement for ws, without any
  # tinkering at the higher level.
  # 
  on_Connect: (args...) =>
    @emit('open', args)
    
  on_Disconnect: (args...) =>
    @emit('close', args)

  on_Message: (data, socket) =>
    @log("on_Message")
    @log(socket)
    @emit('message', data)

  on_Error: (args...) =>
    @emit('error', args)

  # Ok, I don't really understand this, but ...  the connection's
  # socket was provided at object construction, either by the node-ipc
  # server or by the node-ipc client. The socket provided by the
  # client seems to be suitable for sending messages, but the one
  # provided by the server does not, unless it is invoked by the
  # server with the socket as the first arg.
  #
  # So this is my solution, which seems to work so far given minimal
  # testing.  I can start a server, connect with two different clients
  # and send client specific messages to either of them.
  # 
  send: (msg) =>

    # If the connection object was created by a server then @server is
    # defined and we invoke it like this:
    # 
    if @server
      @server.emit(@socket, 'message',
        id: @id
        message: msg)

    # And if the connection object was created by a client then we just
    # invoke it like this:
    # 
    else
      @socket.emit('message',
        id: @id
        message: msg)


exports.Faux_WS = Faux_WS


