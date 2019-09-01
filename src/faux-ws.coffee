#!/usr/bin/env coffee
#
#  faux-ws.coffee
#

ipc = require('node-ipc')
{ EventEmitter } = require('events')

# TODO: Align the type signatures with those in server.coffee and
# client.coffee in ws-rmi/src: 
#
#    class WS_RMI_Server(options, objects)
#    class WS_RMI_Client(@options, @objects, Connection)
# 

  # Connnection should be a sub-class of WS_RMI_Connection in order to
  # create and register desired WS_RMI_Objects at construction.
  #
  constructor: 

# 
class Client

  constructor: (@server_id, @id, config) ->
    @connection = null
    @ipc = ipc
    @ipc.config[k] = v for k,v of config
    @ipc.config.id = @id

  connect: =>
    @ipc.connectTo(@server_id, =>
      socket = @ipc.of[@server_id]
      @connection = new Faux_WS(socket))


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
    connection = new Faux_WS(socket, @ipc.server)
    @connections.push(connection)


random_id = (name) ->
  "#{name}_#{Math.random().toString()[2..]}"


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
#
class Faux_WS extends EventEmitter

  constructor: (@socket, @server) ->
    @id = random_id('faux-ws')
    @socket.on('connect', @on_Connect)
    @socket.on('disconnect', @on_Disconnect)
    @socket.on('app.message', @on_Message)
    @socket.on('error', @on_Error)
    #console.log(socket.destroy))
      
  on_Connect: (args...) =>
    @emit('open', args)
    
  on_Disconnect: (args...) =>
    @emit('close', args)

  on_Message: (data, socket) =>
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



exports.Client = Client    
exports.Server = Server
