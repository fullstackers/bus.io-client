Emitter = require('component-emitter')
Common = require('bus.io-common')
SocketIOClient = require('socket.io-client')

describe 'sending a message with the client to the server', ->

  Given ->
    @server = require('bus.io')(3001)
    @server.out (msg, sock) ->
      sock.emit(msg.action(), msg.message)

  Given -> @Client = requireSubject 'lib', {
    'component-emitter': Emitter
    'socket.io-client': SocketIOClient
    'bus.io-common': Common
  }

  describe 'should receive the message', ->

    Given -> @sock = @Client('ws://localhost:3001')

    When (done) ->
      @sock.on 'connect', =>
        @msg = @sock.message()
        @msg.action('hi').deliver()
      @sock.on 'hi', (msg) =>
        @res = msg
        done()
    
    Then -> expect(@res.id()).toBe @msg.id()
