# Description:
#   Google Fight!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   !googlefight <term1> <term2> - term with the most results wins!
#
# Notes:
#   None
#
# Author:
#   siksia

commify = (number) ->
  [left, right] = number.toString().split('.')

  right = '.' + right if right?
  right ?= ''

  regex = /(\d+)(\d{3})/
  left = left.replace(regex, '$1' + ',' + '$2') while (regex.test(left)) 

  left + right

googleResults = (msg, query, cb) ->
  resultCount = 0
  msg.http("https://ajax.googleapis.com/ajax/services/search/web")
    .query
      v: "1.0"
      q: encodeURIComponent query
    .get() (err, res, body) ->
      results = JSON.parse(body)
      resultCount = parseInt results.responseData.cursor.estimatedResultCount, 10
      cb resultCount
  
module.exports = (robot) ->
  robot.hear /^!googlefight ("[^"]+"|'[^']+'|\S+) ("[^"]+"|'[^']+'|\S+)/i, (msg) ->
    word1 = msg.match[1]
    word2 = msg.match[2]
    
    hits1 = 0
    hits2 = 0
    
    googleResults msg, word1, (resCount1) ->
      hits1 = resCount1
      googleResults msg, word2, (resCount2) ->
        hits2 = resCount2
        
        result = ""
        if hits1 > hits2
          result = "#{word1} wins with #{commify hits1} vs. #{word2} with #{commify hits2}, a difference of #{commify(hits1 - hits2)} votes."
        else if hits2 > hits1
          result = "#{word2} wins with #{commify hits2} vs. #{word1} with #{commify hits1}, a difference of #{commify(hits2 - hits1)} votes."
        else if hits1 == hits2
          result = "It is a draw between #{word1} and #{word2} with #{commify hits1} results."
        else
          result = "I'm confused!"
      
        msg.reply result
