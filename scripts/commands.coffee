# Description:
#   Miscellaneous commands/hooks
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   !topic [--append] <topic> - changes room topic
#   !blame [person] <thing> - blames person for thing
#   hubot join <channel> - tells hubot to join a channel
#   !cred [--add] [person] - gives someone props
#   !wtf [--add] <acronym> [definition] - wtf is something
#   !facepalm - ascii facepalm
#   !stampy [word] - ROAR
#   !merde [word] - poo
#   !yo - YO! 
#
# Notes:
#   None
#
# Author:
#   siksia



module.exports = (robot) ->
  robot.hear /^!topic (--append)? ?(.*)$/i, (msg) ->
    topic = msg.match[2]
    channel = "#{msg.message.user.room}"
    robot.brain.data.channel or= {}
    robot.brain.data.channel[channel] ?= {}
    if msg.match[1] and robot.brain.data.channel[channel].topic
      topic = "#{robot.brain.data.topic} #{topic}"
    
    robot.brain.data.channel[channel].topic = topic
    msg.topic robot.brain.data.channel[channel].topic
    
  robot.hear /^!blame ?(.*)$/i, (msg) ->
    blame = "someone"
    thing = "something"
    channel = "#{msg.message.user.room}"

    blame = msg.random robot.brain.data.channel[channel].names
    thing = msg.match[1] if msg.match[1]
    
    msg.action "blames #{blame} for #{thing}"
    
  robot.respond /join (\#.*)$/i, (msg) ->
    robot.adapter.join msg.match[1] if msg.match[1]
    
  robot.hear /^!cred ?(--add)? ?(.*)$/i, (msg) ->
    robot.brain.data.cred ?= []
    channel = "#{msg.message.user.room}"
    if msg.match[1] and msg.match[2]
      robot.brain.data.cred.push msg.match[2] unless msg.match[2] in robot.brain.data.cred
      msg.reply "Successfully added!"
    else
      nick = msg.random robot.brain.data.channel[channel].names
      nick = msg.match[2] if msg.match[2]
      cred = msg.random robot.brain.data.cred
      console.log "#{nick} #{cred}"
      msg.send cred.replace("NICK", nick)
      
  robot.hear /^!wtf (--add)? ?([A-Za-z0-9]+) ?(.*)$/i, (msg) ->
    robot.brain.data.wtf ?= []
    if msg.match[1] and msg.match[2] and msg.match[3]
      acronym = msg.match[2].toUpperCase()
      definition = msg.match[3]
      robot.brain.data.wtf[acronym] ?= []
      robot.brain.data.wtf[acronym].push definition unless definition in robot.brain.data.wtf[acronym]
      msg.reply "Successfully added!"
    else if msg.match[2]
      acronym = msg.match[2].toUpperCase()
      if robot.brain.data.wtf[acronym]
        wtf = msg.random robot.brain.data.wtf[acronym]
        msg.reply "#{acronym} is #{wtf}"
      else
        msg.reply "I don't know wtf #{acronym}"
      
  robot.hear /^!facepalm/i, (msg) ->
    msg.send "......................________...................."
    msg.send "..................,.-‘”..........``~.,............"
    msg.send "...............,.-”..................“-.,........."
    msg.send ".............,/........................”:,........"
    msg.send "...........,?...........................\\,........"
    msg.send "........../..............................,}......."
    msg.send "........./...........................,:`^`.}......"
    msg.send "......../..........................,:”...../......"
    msg.send ".......?...__.....................:`......../....."
    msg.send "......./__.(...“~-,_...............,:`...../......"
    msg.send "....../(_..”~,_....“~,_..........,:`...._/........"
    msg.send ".....{._$;_...”=,_....“-,_..,.-~-,},.~”;.}........"
    msg.send "......((...*~_....”=-._.“;,,./`../”....../........"
    msg.send ",,,___.\\`~,...“~.,..........`...}......./........."
    msg.send "......(..`=-,,....`............(..;_,,-”.........."
    msg.send "....../.`~,...`-................\\../\\............."
    msg.send ".......\\`~.*-,...................|,..\\,__........."
    msg.send ",,_.....}.>-._\\..................|.......`=~-,...."
    msg.send "..`=~-,_\\_...`\\,.................\\................"
    msg.send "..........`=~-,,.\\,................\\.............."
    msg.send "..................`:,,..............`\\.......__..."
    msg.send "...................`=-,.............,%`>--==``...."
    msg.send "...................._\\.........._,-%....`\\........"
    msg.send "..................,<`..._|_,-&``........`\\........"
    
  robot.hear /^!stampy ?(.*)$/i, (msg) ->
    say = "STAMPY SMASH!!!"
    say = msg.match[1] if msg.match[1]
    msg.send " ,"
    msg.send "((_,-.   ROAR!!!"
    msg.send " '-,\\_)'-,  #{say}"
    msg.send "    )  _ )'-"
    msg.send "   (/(/ \\))"
    
  robot.hear /^!merde ?(.*)$/i, (msg) ->
    say = "Merde!"
    say = msg.match[1] if msg.match[1]
    msg.send "     (   )"
    msg.send "  (   ) (  >@<"
    msg.send "   ) _   )"
    msg.send ">@< ( \\\\_"
    msg.send "  _(_\\\\ \\\\)__  #{say} "
    msg.send " (____\\\\___))"
  
  robot.hear /^!yo/i, (msg) ->
    msg.send "    o     \\o    \\o/   \\o    o    <o     <o>    o>    o"
    msg.send "   .|.     |.    |     /    X     \\      |    <|    <|>"
    msg.send "   / \\     >\\   /<     >\\  /<     >\\    /<     >\\   /<"