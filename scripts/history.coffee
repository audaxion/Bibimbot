# Description:
#   Allows Hubot to store a recent chat history for services like IRC that
#   won't do it for you.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_HISTORY_LINES
#
# Commands:
#   hubot show [<lines> lines of] history - Shows <lines> of history, otherwise all history
#   hubot clear history - Clears the history
#
# Author:
#   wubr



class History
  constructor: (@robot, @keep) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.history
        @robot.logger.info "Loading saved chat history"
        @cache = @robot.brain.data.history

  add: (message) ->
    @cache.push message
    while @cache.length > @keep
      @cache.shift()
    @robot.brain.data.history = @cache

  show: (lines) ->
    if (lines > @cache.length)
      lines = @cache.length
    reply = 'Showing ' + lines + ' lines of history:\n'
    reply = reply + @entryToString(message) + '\n' for message in @cache[-lines..]
    return reply

  entryToString: (event) ->
    return '[' + event.hours + ':' + event.minutes + '] ' + event.name + ': ' + event.message

  findForName: (name, channel, string) ->
    console.log "Searching for \"#{string}\" from #{name} in #{channel}"
    messages = (historyItem.message for historyItem in @cache.slice(0, -1) when (historyItem.name is name and historyItem.channel is channel)).reverse()
    message = (message for message in messages when message.match(new RegExp(@escapeForRegExp(string), "i")))[0]
    return message

  escapeForRegExp: (str) ->
    return str.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")

  clear: ->
    @cache = []
    @robot.brain.data.history = @cache

class HistoryEntry
  constructor: (@name, @channel, @message) ->
    @time = new Date()
    @hours = @time.getHours()
    @minutes = @time.getMinutes()
    if @minutes < 10
      @minutes = '0' + @minutes

module.exports = (robot) ->

  options = 
    lines_to_keep:  process.env.HUBOT_HISTORY_LINES

  unless options.lines_to_keep
    options.lines_to_keep = 10

  history = new History(robot, options.lines_to_keep)

  robot.adapter.bot.addListener 'action', (from, channel, message) ->
    newMessage = "* #{from} #{message}"
    historyentry = new HistoryEntry(from, channel, newMessage)
    history.add historyentry

  robot.hear /(.*)/i, (msg) ->
    if (msg.message.user.room)
      historyentry = new HistoryEntry(msg.message.user.name, msg.message.user.room, "<#{msg.message.user.name}> #{msg.match[1]}")
      history.add historyentry

  robot.respond /remember ([A-Za-z0-9]+) (.+)/i, (msg) ->
    name = msg.match[1]
    
    message = history.findForName(name, msg.message.user.room, msg.match[2])
    if (typeof message isnt 'undefined')
      robot.brain.data.bucket ?= {}
      robot.brain.data.bucket.factoids ?= {}
      factoid_id = robot.brain.data.bucket.factoid_id ?= 1000 
      key = "#{name} quotes"
      robot.brain.data.bucket.factoids[key] ?= []
      factoid = {
        "id": "#{factoid_id}",
        "tidbit": message,
        "verb": "<reply>"
      }
      robot.brain.data.bucket.factoids[key].push factoid
      factoid_id++
      robot.brain.data.bucket.factoid_id = factoid_id
      msg.send "Ok, #{msg.message.user.name}, remembering \"#{message}\""
    else
      msg.send "Sorry, #{msg.message.user.name}, I couldn't find anything about that"

  robot.respond /show ((\d+) lines of )?history/i, (msg) ->
    if msg.match[2]
      lines = msg.match[2]
    else
      lines = history.keep
    msg.send history.show(lines)

  robot.respond /clear history/i, (msg) ->
    msg.send "Ok, I'm clearing the history."
    history.clear()
