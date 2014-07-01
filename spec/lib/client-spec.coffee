debug = require('debug')('bus.io-client')
Emitter = require('component-emitter')
Common = require('bus.io-common')
SocketIOClient = require('socket.io-client')

describe 'the client should tell the server we are a bus.io client and the server should send Message objects', ->

  Given -> @server = require('bus.io')(3000)
  
  Given -> @Client = requireSubject 'lib', {
    'component-emitter': Emitter
    'socket.io-client': SocketIOClient
    'bus.io-common': Common
  }

  Given -> @sock = @Client('ws://localhost:3000')

  When (done) ->
    @sock.on '_flag', (flag) =>
      debug('flag %s', flag)
      @flag = flag
    @sock.on 'connect', =>
      @msg = @sock.message()
      @msg.action('hi').deliver()
    @sock.on 'hi', (msg) =>
      debug('got msg %s %s', msg.id(), msg.content())
      @res = msg
      done()

  Then ->
    debug('ok %s', @flag)
    expect(@flag).toBe 1
    And -> expect(@res.id()).toBe @msg.id()

