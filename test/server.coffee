#!/usr/bin/env coffee
#
#  server.coffee
#

{ Server } = require('./ipc-stack-rmi')
options = require('./settings').ipc_options

console.log options
server = new Server(options)

exports.server = server

