# Description:
#   Atempt to replicate xkcd bucket using hubot
#
# Dependencies:
#   "jsdom": "~0.2.14",
#	"natural": "~0.1.16"
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

class Bucket

	constructor: (@robot) ->
	    @cache = {}
	    
	    @robot.brain.on 'loaded', =>
	      if @robot.brain.data.bucket
	        @cache = @robot.brain.data.bucket

module.exports = (robot) ->