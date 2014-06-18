#/**
# * ChatController
# *
# * @description :: Server-side logic for managing chats
# * @help        :: See http://links.sailsjs.org/docs/controllers
# */

module.exports =
  index: (req,res)->
    res.view({pid: process.pid})

