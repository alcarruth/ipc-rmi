#!/usr/bin/env coffee

{ WS_RMI_Client } = require('./client')
{ WS_RMI_Server } = require('./server')
{ WS_RMI_Connection, WS_RMI_Object, WS_RMI_Stub } = require('./app')

exports.Server = WS_RMI_Server
exports.Client = WS_RMI_Client

exports.Connection = WS_RMI_Connection
exports.Object = WS_RMI_Object
exports.Stub = WS_RMI_Stub