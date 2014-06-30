var debug = require('debug')('bus.io-client');
var slice = Array.prototype.slice;
var emit = require('component-emitter').prototype.emit;
var common = require('bus.io-common');

/*
 * Wrap up socket.io-client
 */

var io = require('socket.io-client');
var lookup = io.connect;
var client = module.exports = function (uri, opts) {
  var sock = lookup(uri, opts);
  sock.on('connect', function () {
    // tells the server we are a bus.io client
    sock.emit('_flag', 1);
  });
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
      this.receiveBuffer.push(args);
    }
  };
  sock.message = function (data) {
    var self = this;
    var builder = common.Builder(data);
    builder.on('built', function (msg) {
      debug('built %s', msg.id());
      self.emit(msg.data.action, msg); 
    });
    return builder;
  };
  return sock;
};
for (var k in io) client[k] = io[k];
client.connect = client;

/*
 * The onevent method will call this method to try and call "emit" 
 * with a message if we have one.
 */

function trigger () {
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
      debug('it is a message %s', args[1].data.id);
      var msg = common.Message(args[1]);
      debug('vivified %s', msg.id());
      emit.apply(this, [args[0], msg ]); 
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
