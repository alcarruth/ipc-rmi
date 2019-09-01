#!/bin/env/ coffee
#
#  ipc_rmi_server
#

ipc = require('node-ipc')
{ RMI_Connection } = require('./app')

class RMI_Server

  # Connection should extend WS_RMI_Connection in
  # order to add desired WS_RMI_Objects at construction.
  #
  constructor: (@path, @options) ->
    @server = net.createServer(null)
    @log_level = @options.log_level || 2
    @log = @options.log || console.log
    @id = "RMI_Server-#{Math.random().toString()[2..]}"
    @connections = []

    @server.on('connect', (socket) =>
      try
        @log("trying new connection: #{socket}")
        conn = new RMI_Connection(this, socket, @log_level)
        @connections.push(conn)
        @log("connection added: #{socket}")
      catch error
        msg = "\nRMI_Server_Common: "
        msg += "\nError in connection event handler"
        new Error(msg))

  # Start the server.
  start: =>
    try
      @server.listen(@path)
      @log("server listening at: #{@path}")

    catch error
     @log error

  # Stop the server.
  stop: =>
    @server.close()
    @log("server stopped.")



exports.RMI_Server = RMI_Server

