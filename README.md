Node.js勉強会 2014/6/14
=========

## Slide

[Scalable Node.js with Redis Store](http://www.slideshare.net/kamiyam/npp02slide)

## Sample

### Express 

```
$ cd sample/ExpressChat
node app.js
```

### RedisStoreを使う

```

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

//...

app.use(express.cookieParser( "secret", session.secret ));

/// SessionStore
app.use(express.session({
  key: session.key,
  cookie: {maxAge: 1000 * 60 * 60 * 24 * 7, "httpOnly":false},
  store: new SessionStore({
    client: client,
    db: 1,
    prefix: 'session:',
    port: 6379,
    host: "localhost"
  })
}));

//...


var io = require('socket.io').listen(server);
var SocketStore = require('socket.io/lib/stores/redis');
io.configure(function() {

  /// Store
  io.set('store', new SocketStore({pub:pub, sub:sub, client:client}));

  io.set('transports', [
  'websocket',
  'htmlfile',
  'xhr-polling'
  ]);

});

```
