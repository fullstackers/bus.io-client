var slice = Array.prototype.slice;
var emit = require('component-emitter').prototype.emit;
var debug = require('debug')('idea');
var bus = require('bus.io')(3000);
bus.out(function (msg, sock) {
  debug('out %s', msg.action());
  msg.consume();
  sock.emit(msg.action(), msg.message);
});

setTimeout(function () {
  var Common = require('bus.io-common');

  var sock = require('socket.io-client')('ws://localhost:3000');
  function trigger () {
    debug('sock', this);
    debug('trigger %j', arguments);
    if (!arguments.length) return;
    var args = slice.call(arguments);
    switch(args.length) {
    case 1:
      debug('one argument');
      emit.apply(this, args);
      break;
    case 2:
      debug('two arguments');
      if (args[1] && args[1].isMessage) {
        debug('it is a message');
        emit.apply(this, [args[0], Common.Message(args[1])]); 
      }
      else {
        debug('it is not a message');
        emit.apply(this, args);
      }
      break;
    default:
      debug('more than one argument');
      emit.apply(this, args);
      break;
    }
  };
  sock.message = function () {
    var self = this;
    var builder = Common.Builder();
    builder.on('publish', function (msg) {
      debug('publish a msg', msg);
      self.emit(msg.data.action, msg); 
    });
    return builder;
  };
  sock.onevent = function (packet) {
    var args = packet.data || [];
    debug('emitting event %j', args);

    if (null != packet.id) {
      debug('attaching ack callback to event');
      args.push(this.ack(packet.id));
    }

    if (this.connected) {
      trigger.apply(this, args);
    } else {
      debug('rceiveBuffer???');
      this.receiveBuffer.push(args);
    }
  }
  sock.on('connect', function () {
    sock.emit('echo', new Date);
  });
  sock.on('echo', function (msg) {
    console.log('msg', msg);
    sock.message().action('hi').deliver();
  });
  sock.on('hi', function (msg) {
    console.log('we got the msg hi', msg);
    process.exit(0);
  });
}, 1000);
