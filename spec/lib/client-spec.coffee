debug = require('debug')('bus.io-client')
Emitter = require('component-emitter')
Common = require('bus.io-common')
SocketIOClient = require('socket.io-client')

server = require('bus.io')(3000)
server.in '_flag', (msg, sock) ->
  msg.consume()
  sock._flag = 1
  sock.emit('_flag', 1)
server.out (msg, sock) ->
  if (sock._flag == 1)
    sock.emit(msg.action(), msg.message)
  else
    sock.emit(msg.action(), msg.actor(), msg.content(), msg.target(), msg.created())

describe 'client', ->
  
  Given -> @Client = requireSubject 'lib', {
    'component-emitter': Emitter
    'socket.io-client': SocketIOClient
    'bus.io-common': Common
  }

  describe 'a bus.io server should flag the socket as a bus.io client and send a message object back', ->

    Given -> @sock = @Client('ws://localhost:3000')

    When (done) ->
      @sock.on '_flag', (flag) =>
        debug('flag %s', flag)
        @flag = flag
      @sock.on 'connect', =>
        debug('connect')
        @msg = @sock.message()
        @msg.action('hi').deliver()
      @sock.on 'hi', (msg) =>
        @res = msg
        done()

    Then ->
      debug('ok %s', @flag)
      expect(@flag).toBe 1
    And -> expect(@res.id()).toBe @msg.id()

