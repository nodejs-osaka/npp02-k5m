do ( d=document, w=window, io=io, port=sailsPort ) ->

  # log output
  log = ->
    if (typeof console isnt 'undefined')
      console.log.apply(console, arguments);

  # for reverse proxy
  details = if port then { port: port } else undefined

  $ ->
    return