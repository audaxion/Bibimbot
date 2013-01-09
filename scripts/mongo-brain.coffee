# Description
#   MongoDB presistence for brain
#
# Dependencies:
#   "mongodb": ">= 1.1.7"
#
# Configuration:
#   MONGOLAB_URI
#
# Commands:
#   None
#
# Notes:
#   None
#
# Author:
#   siksia

Url   = require "url"
mongodb = require "mongodb"

# sets up hooks to persist the brain into mongodb.
module.exports = (robot) ->
  info   = Url.parse process.env.MONGOLAB_URI || 'http://127.0.0.1:27017/hubot'
  # define mongo server and client for hubot database.
  server = new mongodb.Server(info.hostname, (Number) info.port, {})
  # strip leading slash from database name
  client = new mongodb.Db(info.pathname.split("/")[1], server);

  #open a connection
  client.open (err, connection) ->
    if err
      throw err
    else if connection
      # if any authentication info was received.
      if info.auth
        # authenticate against the mongo database
        [username, password] = info.auth.split ":"
        client.authenticate username, password, (err, loggedIn) ->
          if err
            throw err
          else if loggedIn
            connectionOpened robot, client, connection
      else
        connectionOpened robot, client, connection

connectionOpened = (robot, client, connection) ->
  # create or retrieve the collection "storage"
  client.createCollection "storage", (err, collection) ->
    #retrieve the one object from the database collection
    collection.findOne {}, (err, doc) ->
      # if an error ocurs, throw an exception
      if err 
        throw err
      else if doc
        # else, merge the document into the robot brain.
        robot.brain.mergeData doc
        # listen to the "save" event of the robot's brain.

  robot.brain.on 'save', (data) ->
    # retrieve the collection storage.
    connection.collection 'storage', (err, collection) ->
      # save the new data provided by the robot brain.
      collection.save data

  # listen to the "close" event of the robot's brain. robot.brain.on 'close', -> # close the connection
  robot.brain.on 'close', -> 
    connection.close
