#!/usr/bin/env coffee
#
# test_server.coffee
#

{ config } = require('./config')
{ Server } = require('./sockets')

server = new Server('server', config)
server.start()

exports.server = server
