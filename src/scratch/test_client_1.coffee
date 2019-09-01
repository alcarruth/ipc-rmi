#!/usr/bin/env coffee
#
# test_client.coffee
#

{ config } = require('./config')
{ Client } = require('./sockets')

client = new Client('server', 'client_1', config)
client.connect()

exports.client = client
