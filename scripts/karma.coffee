# Description:
#   Track arbitrary karma
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <thing>++ - give thing some karma
#   <thing>-- - take away some of thing's karma
#   !score [--high] - show the top 10
#   !score --low - show the bottom 10
#   !score <thing> - check thing's karma (if <thing> is omitted, show the top 10)
#
# Author:
#   stuartf, siksia

class Karma
  
  constructor: (@robot) ->
    @cache = {}
    
    @increment_responses = [
      "+1!", "gained a level!", "is on the rise!", "leveled up!", "hrheehrhen.", "BOOM!"
    ]
  
    @decrement_responses = [
      "took a hit! Ouch.", "took a dive.", "lost a life.", "lost a level.", "pwned.", "O RLY?"
    ]
    
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.karma
        @cache = @robot.brain.data.karma
  
  kill: (thing) ->
    delete @cache[thing]
    @robot.brain.data.karma = @cache
  
  increment: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] += 1
    @robot.brain.data.karma = @cache

  decrement: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] -= 1
    @robot.brain.data.karma = @cache
  
  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]
  
  decrementResponse: ->
     @decrement_responses[Math.floor(Math.random() * @decrement_responses.length)]

  get: (thing) ->
    k = if @cache[thing] then @cache[thing] else 0
    return k

  sort: ->
    s = []
    for key, val of @cache
      s.push({ name: key, karma: val })
    s.sort (a, b) -> b.karma - a.karma
  
  top: (n = 10) ->
    sorted = @sort()
    sorted.slice(0, n)
    
  bottom: (n = 10) ->
    sorted = @sort()
    sorted.slice(-n).reverse()
  
module.exports = (robot) ->
  karma = new Karma robot
  robot.hear /(\S+[^+\s])\+\+(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    if subject is msg.message.user.name
      karma.decrement for i in [1..5]
      msg.send "#{msg.message.user.name}: No self promotion! You lose 5 points! (Karma: #{karma.get(subject)})"
    else
      karma.increment subject
      msg.send "#{subject} #{karma.incrementResponse()} (Karma: #{karma.get(subject)})"

  robot.hear /(\S+[^-\s])--(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    if subject is msg.message.user.name
      msg.send "#{msg.message.user.name}: Aww, cheer up! You can keep your point."
    else
      karma.decrement subject
      msg.send "#{subject} #{karma.decrementResponse()} (Karma: #{karma.get(subject)})"
  
  robot.hear /^!score( --high)?$/i, (msg) ->
    verbiage = ["High Scores:"]
    for item, rank in karma.top()
      verbiage.push "  #{item.karma} #{item.name}" unless item.karma < 0
    msg.send verbiage.join("\n")
      
  robot.hear /^!score --low$/i, (msg) ->
    verbiage = ["Low Scores:"]
    for item, rank in karma.bottom()
      verbiage.push "  #{item.karma} #{item.name}" unless item.karma > 0
    msg.send verbiage.join("\n")
  
  robot.hear /^!score (\S+[^-\s])\s*$/i, (msg) ->
    match = msg.match[1].toLowerCase()
    exclude = ["--high", "--low"]
    if !(match in exclude) 
      msg.send "#{match} has #{karma.get(match)} points!"
