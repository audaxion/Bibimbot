# Description:
#   Hubot, you complete me
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   HUBOT_GAC_NUMBER
#
# Commands:
#   !gac <phrase> - Google Suggest a phrase
#
# Author:
#   aroben

XMLJS = require("xml2js")

module.exports = (robot) ->
  robot.hear /^!gac (.*)$/i, (msg) ->
    number = process.env.HUBOT_QUOTE_MAX_LINES || 5
    phrase = msg.match[1]
    msg.http('http://google.com/complete/search')
      .query(q: phrase, output: 'toolbar')
      .get() (err, res, body) ->
        parser = new XMLJS.Parser(explicitArray: true)
        parser.parseString body, (err, result) ->
          if !result.CompleteSuggestion
            msg.send "No meatbag has ever searched for \"#{phrase}\""
            return
          suggestions = (x.suggestion[0]['@'].data for x in shuffle(result.CompleteSuggestion)[0..number - 1])
          (msg.send x for x in suggestions)

shuffle = (array) ->
  if array.length > 0
    i = array.length
    until --i == 0
      j = Math.floor(Math.random() * (i + 1))
      [array[i], array[j]] = [array[j], array[i]]
  array
