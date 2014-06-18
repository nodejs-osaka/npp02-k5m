do(w=window,d=document,$=jQuery)->

  w.pageloader = w.pageloader || {}
  return if w.pageloader.index

  # log output
  log = ->
    if (typeof console isnt 'undefined')
      console.log.apply(console, arguments);

  pageSocket = null

  class Loader
    io=window.io
    self = null
    socketer = null
    pageSocket = null

    constructor: ->

      self = this

    ready: ->

      # for reverse proxy
      port=window.sailsPort
      details = if port then { port: port } else undefined

      # Socket.io events binding Class
      socketer = new Socketer( io, details )
      pageSocket = socketer.bind "/chat", ( appSocket, socket ) ->
        log "connect"
      , ->
        log "disconnect"

      chatView = new Vue
        el: '#chat'
        data:
          online: ""
          pid: ""
          items: []

        methods:
          emit: ->

            #メッセージ入力欄が空白でなければメッセージを送信する
            message = this.msg

            return  if message is ""

            name = this.user
            name = "Anonymous"  if not name? or name is ""

            sendData =
              name: name
              message: message

            pageSocket.emit "sendmMssage", sendData
            this.msg = ""

      pageSocket.on "message", (data) ->
        message = data.message
        return  if message is ""

        chatView.$data.items.unshift
          name: data.name
          msg: message

      pageSocket.on "status", (data) ->
        chatView.$data.online = data.online
        chatView.$data.pid = "<= pid:" + data.pid

    destroy: ->
      pageSocket?.disconnect()
      socketer.unbind("/chat")
      return

  w.pageloader.index = ->
    loader = new Loader()
    $ loader.ready
    return loader