io = require("socket.io-client")
url = "http://localhost:1337/counter"
options =
  "force new connection": true
  reconnect: false
  "sync disconnect on unload": true

maxConnect = 200
i = 0

#console.log io

while i < maxConnect

  client = io.connect(url, options)

  console.log client if i is 0

  client.on "connect", ->
    return

  client.on "disconnect", ->
    setTimeout ->
      client.emit "flush", {}
      return
    , 10

  i++
