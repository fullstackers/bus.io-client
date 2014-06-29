EventEmitter = require('events').EventEmitter
Common = require('bus.io-common')
SocketIOClient = require('socket.io-client')

describe 'client', ->

  Given -> @server = require('bus.io')(3000)

  Given -> @Client = requireSubject 'lib', {
    'socket.io-client': SocketIOClient
    'bus.io-common': Common
  }

  describe '#', ->

    When -> @socket = @Client('ws://localhost:3000')
    Then -> expect(@socket instanceof SocketIOClient.Socket).toBe true

    describe '#onevent (packet:Array=[action:String, msg:Message])', ->

      Given -> @emit = EventEmitter.prototype.emit
      Given -> spyOn @emit, 'apply'
      Given -> @msg = Common.Message()
      Given -> @packet = [@msg.action(), @msg]
      When -> @socket.onevent @packet
      Then -> expect(@emit.apply).toHaveBeenCalledWith @socket, [@msg.action(), @msg]

    xdescribe '#message', ->
