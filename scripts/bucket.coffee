# Description:
#   Attempt to replicate xkcd bucket (http://wiki.xkcd.com/irc/bucket) using hubot
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
#   see http://wiki.xkcd.com/irc/bucket for approximate commands
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

irreg = 
  "awake": "awoken",
  "be": "been",
  "bear": "born",
  "beat": "beat",
  "become": "become",
  "begin": "begun",
  "bend": "bent",
  "beset": "beset",
  "bet": "bet",
  "bid": "bid",
  "bind": "bound",
  "bite": "bitten",
  "bleed": "bled",
  "blow": "blown",
  "break": "broken",
  "breed": "bred",
  "bring": "brought",
  "broadcast": "broadcast",
  "build": "built",
  "burn": "burned",
  "burst": "burst",
  "buy": "bought",
  "cast": "cast",
  "catch": "caught",
  "choose": "chosen",
  "cling": "clung",
  "come": "come",
  "cost": "cost",
  "creep": "crept",
  "cut": "cut",
  "deal": "dealt",
  "dig": "dug",
  "dive": "dived",
  "do": "done",
  "draw": "drawn",
  "dream": "dreamed",
  "drive": "driven",
  "drink": "drunk",
  "dye": "dyed",
  "eat": "eaten",
  "fall": "fallen",
  "feed": "fed",
  "feel": "felt",
  "fight": "fought",
  "find": "found",
  "fit": "fit",
  "flee": "fled",
  "fling": "flung",
  "fly": "flown",
  "forbid": "forbidden",
  "forget": "forgotten",
  "forego": "foregone",
  "forgo": "forgone",
  "forgive": "forgiven",
  "forsake": "forsaken",
  "freeze": "frozen",
  "get": "gotten",
  "give": "given",
  "go": "gone",
  "grind": "ground",
  "grow": "grown",
  "hang": "hung",
  "have": "had",
  "hear": "heard",
  "hide": "hidden",
  "hit": "hit",
  "hold": "held",
  "hurt": "hurt",
  "keep": "kept",
  "kneel": "knelt",
  "knit": "knit",
  "know": "know",
  "lay": "laid",
  "lead": "led",
  "leap": "leaped",
  "learn": "learned",
  "leave": "left",
  "lend": "lent",
  "let": "let",
  "lie": "lain",
  "light": "lighted",
  "lose": "lost",
  "make": "made",
  "mean": "meant",
  "meet": "met",
  "misspell": "misspelled",
  "mistake": "mistaken",
  "mow": "mowed",
  "overcome": "overcome",
  "overdo": "overdone",
  "overtake": "overtaken",
  "overthrow": "overthrown",
  "pay": "paid",
  "plead": "pled",
  "prove": "proved",
  "put": "put",
  "quit": "quit",
  "read": "read",
  "rid": "rid",
  "ride": "ridden",
  "ring": "rung",
  "rise": "risen",
  "run": "run",
  "saw": "sawed",
  "say": "said",
  "see": "seen",
  "seek": "sought",
  "sell": "sold",
  "send": "sent",
  "set": "set",
  "sew": "sewed",
  "shake": "shaken",
  "shave": "shaved",
  "shear": "shorn",
  "shed": "shed",
  "shine": "shone",
  "shoe": "shoed",
  "shoot": "shot",
  "show": "showed",
  "shrink": "shrunk",
  "shut": "shut",
  "sing": "sung",
  "sink": "sunk",
  "sit": "sat",
  "sleep": "slept",
  "slay": "slain",
  "slide": "slid",
  "sling": "slung",
  "slit": "slit",
  "smite": "smitten",
  "sow": "sowed",
  "speak": "spoken",
  "speed": "sped",
  "spend": "spent",
  "spill": "spilled",
  "spin": "spun",
  "spit": "spit",
  "split": "split",
  "spread": "spread",
  "spring": "sprung",
  "stand": "stood",
  "steal": "stolen",
  "stick": "stuck",
  "sting": "stung",
  "stink": "stunk",
  "stride": "stridden",
  "strike": "struck",
  "string": "strung",
  "strive": "striven",
  "swear": "sworn",
  "sweep": "swept",
  "swell": "swelled",
  "swim": "swum",
  "swing": "swung",
  "take": "taken",
  "teach": "taught",
  "tear": "torn",
  "tell": "told",
  "think": "thought",
  "thrive": "thrived",
  "throw": "thrown",
  "thrust": "thrust",
  "tread": "trodden",
  "understand": "understood",
  "uphold": "upheld",
  "upset": "upset",
  "wake": "woken",
  "wear": "worn",
  "weave": "weaved",
  "wed": "wed",
  "weep": "wept",
  "wind": "wound",
  "win": "won",
  "withhold": "withheld",
  "withstand": "withstood",
  "wring": "wrung",
  "write": "written"

noDouble = ["abandon", "accouter", "accredit", "adhibit", "administer", "alter", "anchor", "answer", "attrit", "audit",
 "author", "ballot", "banner", "batten", "bedizen", "bespatter", "betoken", "bewilder", "billet", "blacken",
 "blither", "blossom", "bother", "brighten", "broaden", "broider", "burden", "caparison", "catalog", "censor",
 "center", "charter", "chatter", "cheapen", "chipper", "chirrup", "christen", "clobber", "cluster", "coarsen",
 "cocker", "coedit", "cohabit", "concenter", "corner", "cover", "covet", "cower", "credit", "custom", "dampen",
 "deafen", "decipher", "deflower", "delimit", "deposit", "develop", "differ", "disaccustom", "discover",
 "discredit", "disencumber", "dishearten", "disinherit", "dismember", "dispirit", "dither", "dizen",
 "dodder", "edit", "elicit", "embitter", "embolden", "embosom", "embower", "empoison", "empower", "enamor",
 "encipher", "encounter", "endanger", "enfetter", "engender", "enlighten", "enter", "envelop", "envenom",
 "environ", "exhibit", "exit", "fasten", "fatten", "feather", "fester", "filter", "flatten", "flatter",
 "flounder", "fluster", "flutter", "foreshorten", "founder", "fritter", "gammon", "gather", "gladden",
 "glimmer", "glisten", "glower", "greaten", "hamper", "hanker", "happen", "harden", "harken", "hasten",
 "hearten", "hoarsen", "honor", "imprison", "inhabit", "inhibit", "inspirit", "interpret", "iron", "laten",
 "launder", "lengthen", "liken", "limber", "limit", "linger", "litter", "liven", "loiter", "lollop", "louden",
 "lower", "lumber", "madden", "malinger", "market", "matter", "misinterpret", "misremember", "monitor",
 "moulder", "murder", "murmur", "muster", "number", "offer", "open", "order", "outmaneuver", "overmaster",
 "pamper", "pilot", "pivot", "plaster", "plunder", "powder", "power", "prohibit", "reckon", "reconsider",
 "recover", "redden", "redeliver", "register", "rejigger", "remember", "renumber", "reopen", "reposit",
 "rewaken", "richen", "roister", "roughen", "sadden", "savor", "scatter", "scupper", "sharpen", "shatter",
 "shelter", "shimmer", "shiver", "shorten", "shower", "sicken", "smolder", "smoothen", "soften", "solicit",
 "squander", "stagger", "stiffen", "stopper", "stouten", "straiten", "strengthen", "stutter", "suffer",
 "sugar", "summon", "surrender", "swelter", "sypher", "tamper", "tauten", "tender", "thicken", "threaten",
 "thunder", "totter", "toughen", "tower", "transit", "tucker", "unburden", "uncover", "unfetter", "unloosen",
 "upholster", "utter", "visit", "vomit", "wander", "water", "weaken", "whiten", "winter", "wonder", "worsen"]

stem: (word) ->
  if /[bcdfghjklmnpqrstvwxyz][aeiou][bcdfghjklmnpqrstv]$/.test(word)
    word = word.replace /\w$/, (m) -> "#{m}#{m}" unless _.find(noDouble, word)
  return word

past: (word) ->
  return irreg[word] if irreg[word]
  word = stem(word)
  word = word + "ed"
  word = word.replace /([bcdfghjklmnpqrstvwxyz])eed$/, (m) -> "#{m}ed"
  word = word.replace /([bcdfghjklmnpqrstvwxyz])yed$/, (m) -> "#{m}ied"
  word = word.replace /eed$/, (m) -> "#{m}ed"
  return word

gerund: (word) ->
  word = stem(word)
  word = word + "ing"
  word = word.replace /(.[bcdfghjklmnpqrstvwxyz])eing$/, (m) -> "#{m}ing"
  word = word.replace /ieing$/, (m) -> "#{m}ying"
  return word

class Bucket
  constructor: (@robot, @min_factoid_length) ->
    @cache = {}
    self = @
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.bucket
        @robot.logger.info "Loading saved bucket"
        @cache = @robot.brain.data.bucket
      setTimeout (-> self.sayIdleFactoid()), 15*1000

  findFactoidsForKey: (key) ->
    return @cache.factoids[key]

  sayRandomFactoidForKey: (msg, key) ->
    if _.random(0,1) == 1
      return
    factoid = new Factoid(@random(@findFactoidsForKey(key)))
    if (factoid? and factoid.id? and factoid.verb? and factoid.tidbit?)
      @cache.last_factoid_id = factoid.id
      @cache.last_factoid ?= []
      @cache.last_factoid[msg.message.user.room] = factoid.id
      line = @parseFactoid(msg, factoid.say(key))
      switch factoid.verb
        when "<action>" then @robot.adapter.action(msg.message.user, line)
        else @robot.send {user: msg.message.user}, line

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
        return "#{key} #{new Factoid(factoid).sayLiteral()}"

  findFactoidForId: (id) ->
    if id
      key = (key for key, factoids of @cache.factoids when _.find(factoids, (factoid) -> factoid.id is id))[0]
      return {key: key, val: _.find(@findFactoidsForKey(key), (factoid) -> factoid.id is id)} if key

  findFactoidForLastId: (msg) ->
    last_factoid_id = @cache.last_factoid_id
    if msg.message.user.room
      last_factoid_id = @cache.last_factoid[msg.message.user.room]
    return @findFactoidForId(last_factoid_id)

  deleteFactoidForId: (id) ->
    factoid = @findFactoidForId(id)
    @cache.factoids[factoid.key] = _.without(@cache.factoids[factoid.key], factoid.val)
    unless @cache.factoids[factoid.key].length > 0
      delete @cache.factoids[factoid.key]
    @robot.brain.data.bucket = @cache
    return factoid

  deleteLastFactoidId: ->
    @deleteFactoidForId(@cache.last_factoid_id)

  random: (items) ->
    items[ Math.floor(Math.random() * items.length) ]

  listenForFactoid: (msg, message) ->
    matcher = ///
      ^(#{@escapeForRegExp(@robot.name)})(,|:)?\s+ #check to see if hubot is being addressed
      (
      ((what\swas|forget|delete|lookup)\s(that|\#\d+))| #recall or forget factoid
      ((list|create|remove)\svar)| #list, create or remove vars
      ((add|remove)\svalue)| #add, remove value from var
      (var\s\w+\stype)| #change type for var
      (something\srandom)| #something random
      (literal\s(.+))| #literal factoid
      (.+)\s(is|are|<reply>|<action>)\s(.+) #don't trigger on creating factoid
      )
    ///i
    unless message.match(matcher)
      key = @checkForFactoid(message) 
      if key
        @sayRandomFactoidForKey(msg, key)

  sayRandomFactoidForChannel: (channel) ->
    if(@cache.factoids)
      key = @random(_.keys(@cache.factoids))
      msg = "message": {
        "user": {
          "room": "#{channel}"
        }
      }
      @sayRandomFactoidForKey(msg, key)

  sayRandomFactoid: ->
    channels = process.env.HUBOT_IRC_ROOMS.split(",")
    for channel in channels
      @sayRandomFactoidForChannel(channel)

  sayIdleFactoid: ->
    self = @
    @sayRandomFactoid()
    setTimeout (-> self.sayIdleFactoid()), _.random(60,7200)*1000

  parseFactoid: (msg, factoid) ->
    self = @
    oldFactoid = ""
    varItemMatcher = /\$([a-zA-Z_]\w+)/i
    while oldFactoid isnt factoid and varItemMatcher.test(factoid)
      oldFactoid = factoid
      console.log factoid
      factoid = factoid.replace varItemMatcher, (match) ->
        temp = match.replace("$", "")
        if /who/i.test(temp) and msg.message.user.name
          match = msg.message.user.name
        else if /(who|someone)/i.test(temp) and msg.message.user.room
          match = self.random(self.robot.brain.data.channel[msg.message.user.room].names)
        else if /ed$/i.test(temp)
          temp = temp.replace(/ed$/i, "")
          varItem = self.cache.vars[temp]
          if varItem 
            val = self.random(varItem.values)
            if varItem.type is "verb"
              match = past(val)
            else
              match = "#{val}ed"
        else if /ing$/.test(temp)
          temp = temp.replace(/ing$/i, "")
          varItem = self.cache.vars[temp]
          if varItem 
            val = self.random(varItem.values)
            if varItem.type is "verb"
              match = gerund(temp)
            else
              match = "#{temp}ing"
        else if /s$/.test(temp)
          temp = temp.replace(/s$/i, "")
          varItem = self.cache.vars[temp]
          if varItem
            val = self.random(varItem.values)
            if varItem.type is "verb"
              match = verbInflector.singularize(val)
            else if varItem.type is "noun"
              match = nounInflector.pluralize(val)
            else
              match = "#{val}s"
        else
          varItem = self.cache.vars[temp]
          if varItem
            match = self.random(varItem.values)
        return match
    return factoid

  listVars: ->
    _.keys(@cache.vars).join(", ")

  listValsForVar: (key) ->
    return @cache.vars[key].values.join(", ") if @cache.vars[key]

  removeValForVar: (key, val) ->
    varItem = @cache.vars[key]
    if varItem and _.contains(varItem.values, val)
      varItem.values = _.without(varItem.values, val)
      @cache.vars[key] = varItem
      @robot.brain.data.bucket = @cache
      return val

  addValForVar: (key, val) ->
    varItem = @cache.vars[key]
    if varItem and not _.contains(varItem.values, val)
      varItem.values.push val
      @cache.vars[key] = varItem
      @robot.brain.data.bucket = @cache
      return val

  createVar: (key) ->
    @cache.vars[key] = 
      "type": "var",
      "values": []
    @robot.brain.data.bucket = @cache

  removeVar: (key) ->
    if @cache.vars[key]
      delete @cache.vars[key]
      @robot.brain.data.bucket = @cache
      return key

  setVarType: (key, type) ->
    varItem = @cache.vars[key]
    if varItem
      varItem.type = type
      @cache.vars[key] = varItem
      @robot.brain.data.bucket = @cache
      return type

class Factoid
  constructor: (factoid) ->
    if factoid?
      @id = factoid.id if factoid.id?
      @tidbit = factoid.tidbit if factoid.tidbit?
      @verb = factoid.verb if factoid.verb?

  parseTidbit: ->
    return @tidbit

  say: (key) ->
    switch @verb
      when "is", "are" then "#{key} #{@verb} #{@parseTidbit()}"
      else @parseTidbit()

  sayLiteral: ->
    "#{@verb} #{@parseTidbit()} [##{@id}]"

module.exports = (robot) ->

  options = 
    min_factoid_length: process.env.HUBOT_MIN_FACTOID_LENGTH

  unless options.min_factoid_length
    options.min_factoid_length = 2

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
    if msg.match[1] and msg.match[3] and !(/memegen /i.test(msg.match[1]))
      factoid = bucket.addFactoid(msg.match[1], msg.match[2], msg.match[3])
      msg.send "Ok, #{msg.message.user.name}, #{factoid}" if factoid

  robot.respond /(what was|lookup) (that)?(#(\d+))?/i, (msg) ->
    factoid = bucket.findFactoidForLastId() if msg.match[2]
    factoid = bucket.findFactoidForId(msg.match[4]) if msg.match[4]
    if factoid
      msg.send "That was: #{factoid.key} #{new Factoid(factoid.val).sayLiteral()}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /(forget|delete) (that)?(#(\d+))?/i, (msg) ->
    factoid = bucket.deleteLastFactoidId() if msg.match[2]
    factoid = bucket.deleteFactoidForId(msg.match[4]) if msg.match[4]
    if factoid
      msg.send "Ok, #{msg.message.user.name}, forgot that #{factoid.key} #{new Factoid(factoid.val).sayLiteral()}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /literal (.+)/i, (msg) ->
    factoids = bucket.findFactoidsForKey(msg.match[1])
    if factoids
      if factoids.length > 10
        msg.message.user.room = null
      facts = factoids.map (factoid) -> new Factoid(factoid).sayLiteral()
      msg.send "Listing all factoids for #{msg.match[1]}\n#{facts.join("\n")}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /something random/i, (msg) ->
    bucket.sayRandomFactoidForChannel(msg.message.user.room)

  robot.respond /list vars/i, (msg) ->
    msg.send bucket.listVars()

  robot.respond /list var (\S+)/i, (msg) ->
    vals = bucket.listValsForVar(msg.match[1])
    if vals
      msg.send vals
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /add value (\S+) (.+)/i, (msg) ->
    val = bucket.addValForVar(msg.match[1], msg.match[2])
    if val
      msg.send "Ok, #{msg.message.user.name}, added #{val} to #{msg.match[1]}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /remove value (\S+) (.+)/i, (msg) ->
    val = bucket.removeValForVar(msg.match[1], msg.match[2])
    if val
      msg.send "Ok, #{msg.message.user.name}, removed #{val} from #{msg.match[1]}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /create var (\S+)/i, (msg) ->
    bucket.createVar(msg.match[1])
    msg.send "Ok, #{msg.message.user.name}, created var #{msg.match[1]}"

  robot.respond /remove var (\S+)/i, (msg) ->
    varKey = bucket.removeVar(msg.match[1])
    if varKey
      msg.send "Ok, #{msg.message.user.name}, removed var #{varKey}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")

  robot.respond /var (\S+) type (var|verb|noun)/i, (msg) ->
    type = bucket.setVarType(msg.match[1], msg.match[2])
    if type
      msg.send "Ok, #{msg.message.user.name}, var #{msg.match[1]} is now type #{type}"
    else
      bucket.sayRandomFactoidForKey(msg, "don't know")
