/**
 * Module dependencies.
 */
var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');
var numCPUs = require("os").cpus().length;

var app = express();


var session = {
  secret: "your secret here",
  key: "session_id"
}

var redis = require("redis");
var SessionStore = require('connect-redis')(express);

var opts = {host:'localhost', port:6379, key: session.key};
var pub = redis.createClient(opts);
var sub = redis.createClient(opts);
var client = redis.createClient(opts);


// all environments
app.set('port', process.env.PORT || 1337);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());

app.use(express.cookieParser( "secret", session.secret ));

/// SessionStore
app.use(express.session({
  key: session.key,
  cookie: {maxAge: 1000 * 60 * 60 * 24 * 7, "httpOnly":false},
  // store: new SessionStore({
  //   client: client,
  //   db: 1,
  //   prefix: 'session:',
  //   port: 6379,
  //   host: "localhost"
  // })
}));

app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('production' !== app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', routes.index);

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log( process.pid +': Express server listening on port ' + app.get('port'));
});

var io = require('socket.io').listen(server);
var SocketStore = require('socket.io/lib/stores/redis');
io.configure(function() {

  /// Store
  // io.set('store', new SocketStore({pub:pub, sub:sub, client:client}));

  io.set('transports', [
  'websocket',
  'htmlfile',
  'xhr-polling'
  ]);

});

io.sockets.on('connection', function (socket) {
  setTimeout(function(){

    io.sockets.emit('status', {
      "online" : Object.keys(socket.namespace.sockets).length,
      "pid": process.pid
    } );

    socket.emit('message', { 'message' : "Hello" } );

    socket.on('sendMsg', function (data) {
      io.sockets.emit("message",data);
    });

    socket.on( "disconnect", function(){
      io.sockets.emit('status', {
        "online" : Object.keys(socket.namespace.sockets).length,
        "pid": process.pid
      });
    });

  },10);
});
