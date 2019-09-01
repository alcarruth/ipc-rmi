#!/usr/bin/env coffee
#
# connection.coffee
#

random_id = (name) ->
  "#{name}_#{Math.random().toString()[2..]}"

class Connection

  constructor: (@socket, @server) ->
    @id = random_id('connection')
    @socket.on('connect', @on_Connect)
    @socket.on('disconnect', @on_Disconnect)
    @socket.on('app.message', @on_Message)
    @socket.on('error', @on_Error)
    #console.log(socket.destroy))
      
  on_Connect: (args...) =>
    console.log('connected ...')
    console.log("args: #{args}")
    
  on_Disconnect: (args...) =>
    console.log('disconnected...')
    console.log("args: #{args}")

  on_Error: (args...) =>
    console.log('error ...')
    console.log("args: #{args}")

  on_Message: (data, socket) =>
    console.log(data)


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


if module.parent
  exports.Connection = Connection
