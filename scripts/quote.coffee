# Description:
#   Display a random quote or one from a specific person
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_QUOTE_MAX_LINES
#
# Commands:
#   !homer - simpsons quotes
#   !calvin - calvin and hobbes quotes
#   !futurama - futurama quotes
#   !startrek - star trek quotes
#   !starwars - star wars quotes
#   !davebarry - dave barry quotes
#   !holygrail - holy grail quotes
#   !random - random quotes
#
# Author:
#   cldwalker

source_map = {
  homer: "bart+bart_simpson+homer+simpsons_cbg+simpsons_chalkboard+simpsons_homer+simpsons_ralph",
  calvin: "calvin",
  futurama: "futurama",
  startrek: "startrek",
  starwars: "starwars",
  davebarry: "dave_barry",
  holygrail: "holygrail"
}

get_quote = (msg, source = null) ->
  params = {max_lines: process.env.HUBOT_QUOTE_MAX_LINES || '4'}
  if source
    params['source'] = source_map[source]
    
  msg.http('http://www.iheartquotes.com/api/v1/random')
    .query(params)
    .get() (err, res, body) ->
      if err || body.match(/application error/i)
        msg.action "is unable to retrieve quote"
      else
        body = body.replace(/\s*\[\w+\]\s*http:\/\/iheartquotes.*\s*$/m, '')
        body = body.replace(/&quot;/g, "'")
        msg.send body

module.exports = (robot) ->
  robot.hear /^!(homer|calvin|futurama|startrek|starwars|davebarry|holygrail)/i, (msg) ->
    get_quote msg, msg.match[1]
  
  robot.hear /^!random/i, (msg) ->
    get_quote msg
