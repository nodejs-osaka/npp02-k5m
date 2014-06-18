io = require("socket.io-client")
url = "http://localhost:1337"
options =
  "forceNew": true

maxConnect = 50
i = 0

#console.log io
sockets = []

while i < maxConnect

  client = io.connect(url, options)
  sockets.push(client)

  do(socket=client) ->
    setTimeout ->
      socket.emit("sendMsg", {name:"test-client",message: new Date()});
    , 1000

  i++
