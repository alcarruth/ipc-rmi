#!/usr/bin/env coffee
#
#  ipc-stack-rmi.coffee
#

{ Stack } = require('./stack.coffee')
ipc_rmi_socket = require('../src')
rmi = require('../../ws-rmi/src')


class Stack_RMI_Object extends rmi.Object
  constructor: (options = {}) ->
    stack = new Stack()
    method_names = ['push', 'pop']
    super('stack', stack, method_names, options)

class Stack_RMI_Client extends ipc_rmi_socket.Client
  constructor: (options = {}) ->
    objects = []
    super(rmi.Connection, objects, options)

class Stack_RMI_Server extends ipc_rmi_socket.Server
  constructor: (options = {}) ->
    stack_rmi_obj = new Stack_RMI_Object(options)
    super([stack_rmi_obj], options)


exports.Client = Stack_RMI_Client
exports.Server = Stack_RMI_Server
