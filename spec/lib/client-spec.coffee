SocketIOClient = require('socket.io-client')

describe 'client', ->

  Given -> @server = require('bus.io')(3000)

  Given -> @Client = requireSubject 'lib', {
    'socket.io-client': SocketIOClient
  }

  describe '#', ->

    When -> @socket = @Client('ws://localhost:3000')
    Then -> expect(@socket instanceof SocketIOClient.Socket).toBe true

