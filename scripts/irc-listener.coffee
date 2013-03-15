# Description:
#   Custom IRC listeners
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Notes:
#   None
#
# Author:
#   siksia

module.exports = (robot) ->
  @bot = robot.adapter.bot

  robot.adapter.bot.addListener 'join', (channel, who) ->
  	robot.adapter.command 'names', channel

  robot.adapter.bot.addListener 'part', (channel, who, reason) ->
  	robot.adapter.command 'names', channel

  robot.adapter.bot.addListener 'join', (channel, who, _by, reason) ->
  	robot.adapter.command 'names', channel

  robot.adapter.bot.addListener 'names', (channel, nicks) ->
    robot.brain.data.channel or= {}
    robot.brain.data.channel[channel] ?= {}
    robot.brain.data.channel[channel].names = (nick for nick of nicks)

  robot.adapter.action = (user, strings...) ->
    for str in strings
      if not str?
        continue
      if user.room
        console.log "action #{user.room} #{str}"
        @bot.action(user.room, str)
      else
        console.log "action #{user.name} #{str}"
        @bot.action(user.name, str)

  robot.adapter.topic = (user, strings...) ->
    console.log "Changing topic in #{user.room} to #{strings.join(' | ')}"
    @bot.send "topic", user.room, strings.join(' | ')