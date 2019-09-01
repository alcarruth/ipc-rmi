#!/bin/env/ coffee
#
# ws_rmi_client
#

{ RMI_Connection } = require('./app')
net = require('net')

class RMI_Client

  # Connnection must be a sub-class of RMI_Connection in order to
  # create and register desired RMI_Objects at construction.
  #
  constructor: (@options, @path, @objects, Connection) ->
    @log_level = @options.log_level || 2
    @log = @options.log || console.log

    @Connection = Connection || RMI_Connection
    @id = "RMI_Client-#{Math.random().toString()[2..]}"


  #--------------------------------------------------------------------
  # connect() and disconnect() methods
  #

  connect: (path) =>
    new Promise((resolve, reject) =>
      try
        @path = path if path
        @socket = net.connect(@path)
        @log("rmi_client: id:", @id)
        @log("connectiing ...")

        connection = new @Connection(this, @socket, @options)
        resolve(connection)

      catch error
        @log error
        msg = "\nRMI_Client: connect failed."
        msg += " path: #{@path}"
        throw new Error(msg))

  disconnect: =>
    if @log_level > 0
      @log("disconnecting: id: ", @id)
    @socket.close()


exports.RMI_Client = RMI_Client
