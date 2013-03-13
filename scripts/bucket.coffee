# Description:
#   Atempt to replicate xkcd bucket using hubot
#
# Dependencies:
#   "jsdom": "~0.2.14",
#    "natural": "~0.1.16"
#    "underscore": "*"
#
# Configuration:
#   None
#
# Commands:
#
# Notes:
#   None
#
# Author:
#   siksia (ported from zigdon)

natural = require('natural')
nounInflector = new natural.NounInflector()
countInflector = natural.CountInflector
verbInflector = new natural.PresentVerbInflector()
_ = require('underscore')

class Bucket
  constructor: (@robot, @min_factoid_length) ->
    @cache = {}
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.bucket
        @robot.logger.info "Loading saved bucket"
        @cache = @robot.brain.data.bucket

  findFactoidsForKey: (key) ->
    return @cache.factoids[key]

  sayRandomFactoid: (msg, key) ->
    factoid = new Factoid(@random(@findFactoidsForKey(key)))
    if (factoid)
      @cache.last_factoid_id = factoid.id
      switch factoid.verb
        when "<action>" then @robot.adapter.action(msg.message.user, factoid.say(key))
        else @robot.send {user: msg.message.user}, factoid.say(key)

  checkForFactoid: (line) ->
    keys = (key for key, val of @cache.factoids when line.match(new RegExp(@escapeForRegExp(key), "i")))
    if keys.length > 0
      return _.max(keys, (key) -> key.length)

  escapeForRegExp: (str) ->
    return str.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")

  addFactoid: (key, verb, tidbit) ->
    if key.length >= @min_factoid_length
      @cache.factoid_id ?= 1000
      @cache.last_factoid_id = @cache.factoid_id
      factoid = 
        "id": "#{@cache.factoid_id++}",
        "tidbit": tidbit,
        "verb": verb
      @cache.factoids[key] ?= []
      unless _.find(@cache.factoids[key], (factoid) -> (factoid.tidbit is tidbit) and (factoid.verb is verb))
        @cache.factoids[key].push factoid
        @robot.brain.data.bucket = @cache
        return new Factoid(factoid).sayLiteral(key)

  findFactoidForId: (id) ->
    if id
      key = (key for key, factoids of @cache.factoids when _.find(factoids, (factoid) -> factoid.id is id))[0]
      return {key: key, val: _.find(@findFactoidsForKey(key), (factoid) -> factoid.id is id)} if key

  findFactoidForLastId: ->
    return @findFactoidForId(@cache.last_factoid_id)

  deleteFactoidForId: (id) ->
    factoid = @findFactoidForId(id)
    @cache.factoids[factoid.key] = _.without(@cache.factoids[factoid.key], factoid.val)
    @robot.brain.data.bucket = @cache
    return factoid

  deleteLastFactoidId: ->
    @deleteFactoidForId(@cache.last_factoid_id)

  random: (items) ->
    items[ Math.floor(Math.random() * items.length) ]

  listenForFactoid: (msg, message) ->
    matcherString = "#{@escapeForRegExp(@robot.name)}(,|:)? (what was|forget|delete) (that|#\d+)"
    unless message.match(new RegExp(matcherString, "i"))
      key = @checkForFactoid(message) 
      if key
        @sayRandomFactoid(msg, key)

class Factoid
  constructor: (factoid) ->
    @id = factoid.id
    @tidbit = factoid.tidbit
    @verb = factoid.verb

  parseTidbit: ->
    return @tidbit

  say: (key) ->
    switch @verb
      when "is", "are" then "#{key} #{@verb} #{@parseTidbit()}"
      else @parseTidbit()

  sayLiteral: (key) ->
    "#{key} #{@verb} #{@parseTidbit()} [##{@id}]"

module.exports = (robot) ->

  options = 
    min_factoid_length: process.env.HUBOT_MIN_FACTOID_LENGTH

  unless options.min_factoid_length
    options.min_factoid_length = 3

  bucket = new Bucket(robot, options.min_factoid_length)

  robot.adapter.bot.addListener 'action', (from, channel, message) ->
    msg = "message": {
        "user": {
          "name": "#{from}",
          "room": "#{channel}"
        }
      }
    bucket.listenForFactoid(msg, message)

  robot.hear /(.*)/i, (msg) ->
    bucket.listenForFactoid(msg, msg.match[1])

  robot.respond /(.+) (is|are|<reply>|<action>) (.+)/i, (msg) ->
    if msg.match[1] and msg.match[3]
      console.log "#{msg.match[1]}, #{msg.match[2]}, #{msg.match[3]}"
      factoid = bucket.addFactoid(msg.match[1], msg.match[2], msg.match[3])
      msg.send "Ok, #{msg.message.user.name}, #{factoid}" if factoid

  robot.respond /what was that/i, (msg) ->
    factoid = bucket.findFactoidForLastId()
    if factoid
      msg.send "That was: #{new Factoid(factoid.val).sayLiteral(factoid.key)}"
    else
      msg.send "Error: not found!"

  robot.respond /(forget|delete) (that)?(#(\d+))?/i, (msg) ->
    factoid = bucket.deleteLastFactoidId() if msg.match[2]
    factoid = bucket.deleteFactoidForId(msg.match[4]) if msg.match[4]
    if factoid
      msg.send "Ok, #{msg.message.user.name}, forgot that #{new Factoid(factoid.val).sayLiteral(factoid.key)}"
    else
      msg.send "Error: not found!"