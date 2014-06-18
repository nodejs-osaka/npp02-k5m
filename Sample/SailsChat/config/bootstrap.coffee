###
Bootstrap
(sails.config.bootstrap)

An asynchronous bootstrap function that runs before your Sails app gets lifted.
This gives you an opportunity to set up your data model, run jobs, or perform some special logic.

For more information on bootstrapping your app, check out:
http://links.sailsjs.org/docs/config/bootstrap
###

log = ->
  console.log.apply console, arguments  if typeof console isnt "undefined"

socketBind = (room, onConnect, onDisconnect) ->

  io = sails.io

  room = ""  unless typeof (room) is "string"
  unless onConnect?
    onConnect = (appSocket, roomSocket, socket) ->
      log "implements function on Connect"
      return

  return roomSocket = io.of(room).on "connection", (socket) ->

    if onDisconnect
      socket.on "disconnect", ->
        onDisconnect io.sockets, roomSocket, socket

#    setTimeout ->
    onConnect io.sockets, roomSocket, socket
#    , 100

module.exports.bootstrap = (cb) ->

  # total count
  counterRoom = "/counter"
  socketBind counterRoom, onConnect = (appSocket, roomSocket, socket) ->

    count = Object.keys(roomSocket.sockets).length
    console.log "application connect count:open is " + count

    #      console.log( roomSocket.sockets );
    appSocket.emit "count",
      status: "OK"
      results:
        count: count
        pid: process.pid

    socket.on "flush", (data)->

      count = Object.keys(roomSocket.sockets).length
      appSocket.emit "count",
        status: "OK"
        results:
          count: count
          pid: process.pid

    socket.on "messege", (data)->
      log "message", data

  , onDisconnect = (appSocket, roomSocket, socket) ->

      count = Object.keys(roomSocket.sockets).length
      console.log "application connect count:close is " + count
      appSocket.emit "count",
        status: "OK"
        results:
          count: count
          pid: process.pid
#
#  # page spot
#  socketBind "/index", onConnect = (appSocket, roomSocket, socket) ->
#    socket.emit "connected", "connected"
#    socket.on "load", (data)->
#      log data
#
#  , onDisconnect = (appSocket, roomSocket, socket) ->
#      return

  # page spot
  socketBind "/chat", onConnect = (appSocket, roomSocket, socket)->
#    setTimeout ->

      roomSocket.emit "status",
        pid: process.pid
        online: Object.keys(socket.namespace.sockets).length

      socket.emit "message",
        message: "Hello"

      socket.on "sendmMssage", (data) ->

        roomSocket.emit "message", data

      socket.on "disconnect", ->
        roomSocket.emit "status",
          pid: process.pid
          online: Object.keys(socket.namespace.sockets).length

#    , 10





  # It's very important to trigger this callack method when you are finished
  # with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)
  cb()