[![Build Status](https://travis-ci.org/turbonetix/bus.io-client.svg?branch=master)](https://travis-ci.org/turbonetix/bus.io-client)
[![NPM version](https://badge.fury.io/js/bus.io-client.svg)](http://badge.fury.io/js/bus.io-client)
[![David DM](https://david-dm.org/turbonetix/bus.io-client.png)](https://david-dm.org/turbonetix/bus.io-client.png)

![Bus.IO](https://raw.github.com/turbonetix/bus.io/master/logo.png)

The client interface for bus.io. Built on top of [socket.io-client](https://npmjs.org/package/socket.io-client "socket.io-client").

`npm install bus.io-client`

```javascript
var sock = require('bus.io-client')('ws://localhost:3000');
sock.on('connect', function () {
  sock.message()
    .action('say')
    .content('hello')
    .deliver();
});
sock.on('say', function (msg) {
  console.log(msg.content());
});
```

# Features

* Exposes underlying [socket.io-client](https://npmjs.org/package/socket.io-client "socket.io-client") interface.
* Sends and Receives `Message` objects.
* Runs in the browser too.

# Installation and Environment Setup

Install node.js (See download and install instructions here: http://nodejs.org/).

Clone this repository

    > git clone git@github.com:turbonetix/bus.io-client.git

cd into the directory and install the dependencies

    > cd bus.io-client
    > npm install && npm shrinkwrap --dev

# Running Tests

Install coffee-script

    > npm install coffee-script -g

Tests are run using grunt.  You must first globally install the grunt-cli with npm.

    > sudo npm install -g grunt-cli

## Unit Tests

To run the tests, just run grunt

    > grunt spec
