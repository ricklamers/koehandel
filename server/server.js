///<reference path="lib/node.d.ts" />
var app = require('express')(), server = require('http').createServer(app), io = require('socket.io').listen(server);

var game = require('./Game');

var theGame = new game.Game();
//# sourceMappingURL=server.js.map
