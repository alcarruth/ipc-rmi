#!/usr/bin/env coffee

{ IPC_RMI_Client } = require('./client')
{ IPC_RMI_Server } = require('./server')

exports.Server = IPC_RMI_Server
exports.Client = IPC_RMI_Client
