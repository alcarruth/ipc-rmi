#!/usr/bin/env coffee
#
#  client.coffee
#

{ Client } = require('./ipc-stack-rmi')
options = require('./settings').local_options

client = new Client(options)

exports.client = client
