///<reference path="lib/node.d.ts" />

var app = require('express')()
    , server = require('http').createServer(app)
    , io = require('socket.io').listen(server);

import game = require('./Game');

var theGame:game.Game = new game.Game();







