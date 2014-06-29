var debug = require('debug')('bus.io-client')
var io = require('socket.io-client');
var lookup = io.connect;
var client = function (uri, opts) {
  var sock = lookup(uri, opts);
  return sock;
};
for (var k in io) client[k] = io[k];
client.connect = client;
module.exports = client;

