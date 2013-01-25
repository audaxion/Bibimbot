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