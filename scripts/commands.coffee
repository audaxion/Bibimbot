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
#   hubot part <channel> - tells hubot to leave a channel
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
    user = "#{msg.message.user.name}"
    robot.brain.data.channel or= {}
    robot.brain.data.channel[channel] ?= {}
    if msg.match[1] and robot.brain.data.channel[channel].topic
      topic = "#{robot.brain.data.channel[channel].topic} #{topic}"
    
    robot.brain.data.channel[channel].topic = topic
    console.log robot.brain.data.channel[channel].topic
    robot.adapter.topic(msg.message.user, "#{topic}")
    
  robot.hear /^!blame ?(.*)$/i, (msg) ->
    blame = "someone"
    thing = "something"
    channel = "#{msg.message.user.room}"
    user = "#{msg.message.user.name}"

    blame = msg.random robot.brain.data.channel[channel].names
    thing = msg.match[1] if msg.match[1]
    
    robot.adapter.action(msg.message.user, "blames #{blame} for #{thing}")
    
  robot.respond /join (\#.*)$/i, (msg) ->
    robot.adapter.join msg.match[1] if msg.match[1]

  robot.respond /part (\#.*)$/i, (msg) ->
    robot.adapter.part msg.match[1] if msg.match[1]
    
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
      msg.send cred.replace(/NICK/g, nick)
      
  robot.hear /^!wtf (--add)? ?([A-Za-z0-9]+) ?(.*)$/i, (msg) ->
    robot.brain.data.wtf ?= {}
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

  robot.hear /^!populatevars/i, (msg) ->
    msg.send "VARS"
    robot.brain.data.bucket.vars = {
            "verb":{
                "type":"verb",
                "values":[                    "hug", "kiss", "listen", "run", "shriek", "sleep", "smash", "talk", "use", "walk"                ]
            },
            "noun":{
                "type":"noun",
                "values":[                    "acid", "acorn", "bacon", "battery", "beef", "cake", "comic", "device", "factoid", "galaxy", "idea", "magic", "mindjail", "phone", "potato", "salami", "shirt", "sword", "tooth", "wrench"                ]
            },
            "adjective":{
                "type":"var",
                "values":[                    "adorable", "cold", "fast", "fuzzy", "gigantic", "hairless", "hairy", "hot", "huge", "iridescent", "lukewarm", "moldy", "repulsive", "rough", "royal", "sharp", "shiny", "slow", "smelly", "smooth", "sparkly", "spicy", "spikey", "spooky", "squishy", "sticky", "tangy", "tiny", "warm", "windy", "wonky"                ]
            },
            "digit":{
                "type":"var",
                "values":[                    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"                ]
            },
            "preposition":{
                "type":"var",
                "values":[                    "across", "at", "behind", "between", "excluding", "in", "near", "on", "opposite", "over", "regarding", "under", "upon", "via", "within"                ]
            },
            "color":{
                "type":"var",
                "values":[                    "blue", "cerulean", "chartreuse", "indigo", "mahogany", "maroon", "octarine", "plum", "puce", "red", "saffron", "teal"                ]
            },
            "article":{
                "type":"var",
                "values":[                    "a", "the"                ]
            },
            "weekday":{
                "type":"var",
                "values":[                    "Friday", "Monday", "Saturday", "Sunday", "Thursday", "Tuesday", "Wednesday"                ]
            },
            "band":{
                "type":"var",
                "values":[                    "alert inspector bizlogic", "Alpine Shark Attack", "away from openvpn", "bancomicsans is cool", "binder is awesome", "bl party today", "call or irc", "can we help", "Cant talk zombies", "coal creek pkwy", "cogito ergo yum", "could be stationgateposition", "crapitty crap crapper", "did you ride", "except exceptions excellently", "fish are friends", "for his triggers", "from outer space", "gbarta is cool", "gbarta kicking butt", "give you up", "googlefight andrew george", "googlefight ken ryu", "googlefight renton newcastle", "googlefight robb rob", "googlefight scrum waterfall", "hes dead jim", "hipstersia", "hmmm yes quite", "hows it going", "humans are friends", "I am beautiful", "I am dumb", "I am great", "I am obnixious", "I dont know", "I have TOAST", "I know this", "I mean bizlogic", "I NEED SOMEBODY", "i thought so", "in ASUS nonetheless", "Internet Robot Cats", "issue with totalTime", "it is certain", "just doing it", "kill all humans", "let you down", "Leta doing well", "lol just 2", "longcat is long", "maybe demo data", "moore has it", "no caching yet", "no time select", "NOT JUST ANYBODY", "not sure checking", "not the core", "not the face", "Oh Hail No", "oh only 4", "ok gotta go", "ok not all", "One Tectura Tradewinds", "onetectooda loves apple", "only in attitude", "only took 45min", "ouch bad speeling", "ph0rman hates spiders", "PikaJim is cool", "please ask manatee", "points all around", "push button scenario", "Ravi is cool", "reminiscent of phreaking", "siksia is clutch", "siksia is cool", "siksia is rad", "siksia is sick", "siksia is tight", "siksia is wicked", "since its new", "sky is blue", "so on hold", "Team is cool", "The Simple Sounds", "there is hope", "there we go", "theyre aircraft comments", "UNCAUGHT EXCEPTION TERMINATING", "very good movie", "water is wet", "we be jamin", "What are you", "what is cool", "what is heads", "who is cool", "why no work", "Wobbly Tunes", "works for me", "yeah fix that", "yeah thats right", "yeah working fine"                ]
            },
            "weapon":{
                "type":"noun",
                "values":[                    "crowbar", "maint log", "nunchucks", "running chainsaw", "sheep and a wheat", "spoon", "sword"                ]
            },
            "bodypart":{
                "type":"noun",
                "values":[                    "face", "foosball", "spleen"                ]
            },
            "insult1":{
                "type":"var",
                "values":[                    "artless", "bawdy", "beslubbering", "bootless", "churlish", "clouted", "cockered", "craven", "currish", "dankish", "dissembling", "droning", "errant", "fawning", "fobbing", "frothy", "froward", "gleeking", "goatish", "gorbellied", "impertinent", "infectious", "jarring", "loggerheaded", "lumpish", "mammering", "mangled", "mewling", "paunchy", "pribbling", "puking", "puny", "qualling", "rank", "reeky", "roguish", "ruttish", "saucy", "spleeny", "spongy", "surly", "tottering", "unmuzzled", "vain", "venomed", "villainous", "warped", "wayward", "weedy", "yeasty"                ]
            },
            "insult2":{
                "type":"var",
                "values":[                    "base-court", "bat-fowling", "beef-witted", "beetle-headed", "boil-brained", "clapper-clawed", "clay-brained", "common-kissing", "crook-pated", "dismal-dreaming", "dizzy-eyed", "doghearted", "dread-bolted", "earth-vexing", "elf-skinned", "fat-kidneyed", "fen-sucked", "flap-mouthed", "fly-bitten", "folly-fallen", "fool-born", "full-gorged", "guts-griping", "half-faced", "hasty-witted", "hedge-born", "hell-hated", "idle-headed", "ill-breeding", "ill-nurtured", "knotty-pated", "milk-livered", "motley-minded", "onion-eyed", "plume-plucked", "pottle-deep", "pox-marked", "reeling-ripe", "rough-hewn", "rude-growing", "rump-fed", "shard-borne", "sheep-biting", "spur-galled", "swag-bellied", "tardy-gaited", "tickle-brained", "toad-spotted", "unchin-snouted", "weather-bitten"                ]
            },
            "insult3":{
                "type":"var",
                "values":[                    "apple-john", "baggage", "barnacle", "bladder", "boar-pig", "bugbear", "bum-bailey", "canker-blossom", "clack-dish", "clotpole", "codpiece", "coxcomb", "death-token", "dewberry", "flap-dragon", "flax-wench", "flirt-gill", "foot-licker", "fustilarian", "giglet", "gudgeon", "haggard", "harpy", "hedge-pig", "horn-beast", "hugger-mugger", "joithead", "lewdster", "lout", "maggot-pie", "malt-worm", "mammet", "measle", "minnow", "miscreant", "moldwarp", "mumble-news", "nut-hook", "pigeon-egg", "pignut", "pumpion", "puttock", "ratsbane", "scut", "skainsmate", "strumpet", "varlot", "vassal", "wagtail", "whey-face"                ]
            }
        }

  robot.hear /^!populatedefaults/i, (msg) ->
    msg.send "POPULATING..."
    robot.brain.data.cred = [        
        "NICK once compressed a bit to half its size",
        "NICK is a perfect random number generator",
        "NICK's phone number is PI",
        "2+2=5 for very large values of NICK",
        "Your firewall cannot block www.NICK.com",
        "The decimal expansion of PI somewhere contains '789NICK987' but only NICK knows where",
        "NICK rounds to infinity",
        "NICK knows your password",
        "NICK can whistle white noise",
        "NICK once decrypted a box of AlphaBits",
        "NICK's infinite loops bend spacetime",
        "NICK created a new universe by coding a branch predictor",
        "NICK daydreams in PHP",
        "NICK can dereference NULL pointers",
        "NICK once decompiled System 7 - in his sleep",
        "NICK is a perfect random number generator",
        "NICK once rewrote the entire SETI array controller software overnight because it smelled",
        "NICK can de-link any wiki with a single glance",
        "NICK can out href Tim Berners-Lee blindfolded",
        "NICK only speaks one language, C, he writes interpreters for the rest (including English)",
        "NICK rewrote the DaVinci Code to support multithreading",
        "NICK is instruction set agnostic",
        "NICK has two speeds: Walk and Kill",
        "If you ROT13 any elliptical key it reads NICKNICK...",
        "The real reason Spock traveled back in time was to talk to NICK",
        "Daleks fear NICK more than the Doctor",
        "NICK doesn't trade stock... He pwns them",
        "NICK destroyed the periodic table, because NICK only recognizes the element of surprise",
        "NICK imparts knowledge... via roundhouse kicks to the head",
        "NICK influences change... via direct neural stimulation",
        "NICK once re-indexed the library of congress according to MD5 sum",
        "NICK's Hello World code became self-aware 12.3 seconds after initial compilation",
        "SharePoint is what happened when NICK fell asleep at the keyboard",
        "NICK once wrote a 68K disassembler in 68K assembly",
        "NICK once bootstrapped the entire internet using nothing but flip-switches",
        "NICK programmed Windows on a lark, using nothing but zeros",
        "NICK designed an OR gate... Using nothing but ones",
        "NICK can create a FPGA using toothpicks and a wire clothes hanger",
        "NICK was a kindergartener when he created Java",
        "NICK designed Java using modeling clay (NICK used green for java.math)",
        "The kernel once tried to cross NICK.  It was promptly sent a SIGKILL.",
        "NICK can SIGKILL anything",
        "NICK doesn't write documentation.  The code documents itself (out of fear)",
        "In preschool NICK fingerpainted EEPROMs.",
        "NICK once killed a man.  In javascript",
        "NICK eats loosely typed languages for breakfast",
        "NICK likes interpreted languages for the extra fiber",
        "NICK thinks interpreted languages are for sissies",
        "NICK has a dedicated T-1 for his alarm clock",
        "NICK only uses sentences with even parity",
        "NICK has more friends than Tom",
        "NICK actually owns IBM.  It was an extremely hostile takeover",
        "NICK has tagged everything",
        "NICK knows what Scooby would do",
        "NICK knows what Willis is talkin' 'bout",
        "NICK is so 1337 he's 0x7a69",
        "NICK can rewrite any BIOS with 4 keystrokes",
        "Microsoft's entire product line is based on doodles from NICK's notepad",
        "NICK first virus evolved into Windows 98",
        "NICK can access private members",
        "NICK does pointer calculus",
        "NICK can compute the integral of a pointer... in his head",
        "All NICK's types are strong",
        "All NICK's code passes the turing test",
        "NICK greps binary",
        "NICK diffs XML",
        "NICK 3-way merges binary",
        "NICK can fsck by feel",
        "General Failure resigned his comission after meeting NICK",
        "When Windows met NICK, it froze",
        "Oracle only locked pessimisticly until it met NICK",
        "NICK speaks IPSec",
        "NICK can read in SHA1",
        "All PGP is cleartext to NICK",
        "NICK has the kernel memorized... in binary... backwards",
        "NICK makes a yearly pilgrimidge to Linus' apartment",
        "NICK is free as in beer",
        "NICK's AJAX requests once destroyed a small village",
        "The Borg will adapt to service NICK",
        "NICK's only core dump wiped out the dinosaurs",
        "NICK can reboot any computer... with mind bullets",
        "NICK once interrogated his video subsystem so hard that it degaussed",
        "NICK doesn't use boot discs.  He connects to computers like RoboCop",
        "NICK charges all his gadgets wirelessly with current inducted from his brain",
        "NICK only uses SSL'd sign language",
        "NICK has his public key tattooed to his forehead",
        "NICK SHA1 hashed Pi... in his head",
        "NICK uses the metric assload as a unit of measure even though it is only 0.621371992 of an English assload and is so confusing that nobody else uses it on a daily basis.",
        "Only NICK understands how big a metric assload really is",
        "NICK groks *",
        "NICK can kill a process with his mind",
        "NICK is able to persudae large masses with a single squeek",
        "NICK has his own timezone - Universal NICK Time",
        "NICK doesn't wear a watch, atomic clocks synchronize to NICK",
        "NICK only talks to himself because no one else is worth talking to",
        "In a fight between Einstein and Bill Gates, NICK would win",
        "NICK messes with Texas",
        "NICK's brain dumps measure on the richter scale",
        "NICK can divide by zero",
        "NICK counted to infinity - twice",
        "NICK doesn't wear a watch, NICK decides what time it is",
        "NICK can slam a revolving door",
        "NICK can walk through firewalls",
        "NICK knows how to write a duff's device from memory",
        "NICK's function calls do not have parameters, they have arguments, and they ALWAYS WIN!",
        "NICK serializes objects straight into your mind.",
        "NICK doesn't deploy web applications, he roundhouse kicks them into the server.",
        "NICK's favorite design pattern is the Behavioral pattern Roundhouse Kick.",
        "NICK could use anything in java.util.* to kill you, including the javadocs.",
        "NICK can hit you so hard your web app will turn into a swing application... a very bad swing application containing lots of icons of human skulls.",
        "NICK demonstrated the meaning of Float.POSITIVE_INFINITY by counting to it, twice.",
        "A synchronize doesn't protect against NICK, if he wants the object, he takes it.",
        "NICK doesn't use javac, he codes java by using a binary editor on the class files.",
        "NICK's Java code never needs to be optimized. His code is so fast that it broke the speed of light during a test run in Sun's labs, killing 37 and wounding 129.",
        "When someone attempts to use one of NICK's deprecated methods, they automatically get a roundhouse kick to the face at compile time.",
        "The java.lang package originally contained a NICK class, but it punched its way out the package during a design review and roundhouse kicked Bill Joy in the face.",
        "NICK never has a bug in his code, EVER!",
        "NICK doesn't write code. He glares at the screen until progam he wants codes itself out of fear.",
        "Code runs faster when NICK watches it.",
        "NICK' binary edited classes ignore Java bytecode verifier.",
        "NICK methods doesn't catch exceptions becuase no one has the guts to throw any at them.",
        "NICK can cast a value to any type just by nodding at it.",
        "If you get a NICKException you'll probably die.",
        "NICK is the only one who can use goto and const in Java.",
        "NICK can force Java code to compile in .NET just by staring at it.",
        "NICK's code can roundhouse kick all other Java Objects' privates",
        "The full set of Java visibility levels are public, default, protected, private and protected by NICK; do NOT try to access a field with this last modifier!",
        "NICK eats JavaBeans and Roundhouse Kicks JavaServer Faces!",
        "Garbage collector only runs on NICK's code to collect the bodies.",
        "NICK code uses agressive heap natively",
        "When a CPU loads a NICK class file, it doubles the speed.",
        "NICK can execute 64bit length instructions in a 32bit CPU",
        "NICK implements \"Indestructible\". All the others implements \"Killable\".",
        "NICK once roundhouse kicked a Java class very hard. The result is known as a inner class.",
        "NICK can do multiple inheritance in Java.",
        "JVM never throws exceptions to NICK, not anymore. 753 dead Oracle engineers is enough.",
        "NICK doesn't need unit tests because his code always work. ALWAYS.",
        "NICK extends God.",
        "NICK workstation has so memory and it's so powerful that he could run all java applications in the world and get 2% of resources usage.",
        "NICK has coded with generics since 1.3.",
        "NICK' classes can't be decompiled - don't even bother trying.",
        "NICK always wins at Planning Poker.",
        "NICK can do 6-month sprints.",
        "NICK is never late to standup.",
        "NICK answers only 2 questions at standup, as NICK is un-blockable.",
        "NICK can pair program alone",
        "NICK doesn't do burn-down charts, NICK does smack-down charts.",
        "NICK doesn't iterate, it's always right the first time... forever.",
        "NICK uses dependency injection for IRS 1040.",
        "NICK is able to channel his hatred of NFS into electricity",
        "NICK cloned Stampy so he would always have a trunk reservation",
        "NICK doesn't reserve trunk, trunk reserves NICK",
        "NICK knows if you REALLY have comm available",
        "NICK is over 9000",
        "NICK shot first",
        "NICK has altered the deal; pray NICK doesn't alter it any further",
        "NICK can coerce ANY map.  Guess who just shortened their commute?",
        "NICK knows where the party's at",
        "NICK is responsible for something"    
    ]
    robot.brain.data.wtf = {
        "ELB":["Electronic Logbook"],
        "SNAFU":["Situation Normal All Fucked Up"],
        "PFM":["Pure Fucking Magic"],
        "ph0rman":["a really great guy"],
        "AOP":["Aspect-Oriented Programming"],
        "brevatte":["Half half-and-half (breve), half milk (latte) equals brevatte!"],
        "PITA":["Performance Improvements Tasks and Analysis"],
        "TNG":["The Next Generation"],
        "OTTOYH":["Off The Top Of Your Head"],
        "OTTOMH":["Off The Top Of My Head"],
        "HLDGAOY":["Hasta Lasagna Don't Get Any On Ya!"],
        "LSSP":["Line Replaceable Unit Support System Program (Part)"],
        "OMG":["Oh My God"],
        "icd":["I Can't Document"],
        "BOFH":["Bastard Operator From Hell"],
        "toast":["a slice of bread that is lightly burned on one or both sides"],
        "cfdc":["Caffeine Free Diet Coke"],
        "POIDH":["Pictures Or It Didn't Happen"],
        "jad":["Joint Application Development"]
    }
    robot.brain.data.bucket = {
        "factoids":{
            "!stampy":[
                {
                    "id":"67",
                    "tidbit":"runs for the hills",
                    "verb":"<action>"
                }
            ],
            "42":[
                {
                    "id":"44",
                    "tidbit":"the answer",
                    "verb":"is"
                }
            ],
            "act natural":[
                {
                    "id":"154",
                    "tidbit":"whistles nonchalantly",
                    "verb":"<action>"
                }
            ],
            "acts natural":[
                {
                    "id":"155",
                    "tidbit":"whistles nonchalantly",
                    "verb":"<action>"
                }
            ],
            "ain't nothing":[
                {
                    "id":"178",
                    "tidbit":"GONNA BREAK MY STRIDE",
                    "verb":"<reply>"
                },
                {
                    "id":"179",
                    "tidbit":"GONNA SLOW ME DOWN",
                    "verb":"<reply>"
                },
                {
                    "id":"180",
                    "tidbit":"LIKE THE REAL THING, BABY",
                    "verb":"<reply>"
                },
                {
                    "id":"181",
                    "tidbit":"but a chicken wing",
                    "verb":"<reply>"
                }
            ],
            "all you do":[
                {
                    "id":"199",
                    "tidbit":"talk",
                    "verb":"is"
                },
                {
                    "id":"247",
                    "tidbit":"drink",
                    "verb":"is"
                }
            ],
            "and there was much rejoicing":[
                {
                    "id":"187",
                    "tidbit":"HOORAY!",
                    "verb":"<reply>"
                }
            ],
            "Automatic Haiku":[
                {
                    "id":"109",
                    "tidbit":"heads to mtg / this dude is pretty good tho / shimabukuro++",
                    "verb":"<reply>"
                },
                {
                    "id":"117",
                    "tidbit":"something random / what are you talking about? / something random",
                    "verb":"<reply>"
                },
                {
                    "id":"267",
                    "tidbit":"!weather washington / !weather washington, DC / packs an umbrella",
                    "verb":"<reply>"
                },
                {
                    "id":"239",
                    "tidbit":"roger, brt / Coffee Creatures is a band / signs off from linux",
                    "verb":"<reply>"
                },
                {
                    "id":"236",
                    "tidbit":" you are very cool / IZ CANS ONLYS TALKS IN LOLZ / MESSA COOLIOS",
                    "verb":"<reply>"
                },
                {
                    "id":"251",
                    "tidbit":"something random / <ph0rman> siksia++ / something random",
                    "verb":"<reply>"
                },
                {
                    "id":"271",
                    "tidbit":"me neither, too HRish / i only want an aes group / ok, let's delete it",
                    "verb":"<reply>"
                },
                {
                    "id":"381",
                    "tidbit":"toast pops nicely tho / yeah what's going on with that? / contstant_alert_flux--",
                    "verb":"<reply>"
                },
                {
                    "id":"386",
                    "tidbit":"oh great, here it comes / dad i NEED a new iphone / haters gonna hate",
                    "verb":"<reply>"
                }
            ],
            "bananas":[
                {
                    "id":"145",
                    "tidbit":"B A N A N A S",
                    "verb":"<reply>"
                }
            ],
            "bancomicsans quotes":[
                {
                    "id":"84",
                    "tidbit":"<bancomicsans> you know what humans are you dumb robot",
                    "verb":"<reply>"
                }
            ],
            "band name reply":[
                {
                    "id":"1",
                    "tidbit":"\"$band\" would be a good name for a band.",
                    "verb":"<reply>"
                },
                {
                    "id":"2",
                    "tidbit":"\"$band\" would be a nice name for a band.",
                    "verb":"<reply>"
                },
                {
                    "id":"3",
                    "tidbit":"\"$band\" would be a nice name for a rock band.",
                    "verb":"<reply>"
                },
                {
                    "id":"4",
                    "tidbit":"\"$band\" would make a good name for a band.",
                    "verb":"<reply>"
                },
                {
                    "id":"5",
                    "tidbit":"\"$band\" would make a good name for a rock band.",
                    "verb":"<reply>"
                },
                {
                    "id":"6",
                    "tidbit":"That would be a good name for a band.",
                    "verb":"<reply>"
                }
            ],
            "bands":[
                {
                    "id":"88",
                    "tidbit":"made from rubber",
                    "verb":"are"
                }
            ],
            "base":[
                {
                    "id":"353",
                    "tidbit":"http://aybabtu-khan.ytmnd.com/",
                    "verb":"is"
                }
            ],
            "bender":[
                {
                    "id":"57",
                    "tidbit":"great",
                    "verb":"is"
                },
                {
                    "id":"58",
                    "tidbit":"a drunk",
                    "verb":"is"
                },
                {
                    "id":"173",
                    "tidbit":"beautiful",
                    "verb":"is"
                },
                {
                    "id":"197",
                    "tidbit":"the main reason I don't IRC",
                    "verb":"is"
                },
                {
                    "id":"242",
                    "tidbit":"dumb",
                    "verb":"is"
                },
                {
                    "id":"278",
                    "tidbit":"obnixious",
                    "verb":"is"
                },
                {
                    "id":"321",
                    "tidbit":"an imposter",
                    "verb":"is"
                },
                {
                    "id":"82",
                    "tidbit":"<bender> I already have bananas.",
                    "verb":"<reply>"
                },
                {
                    "id":"327",
                    "tidbit":"<bender> ph0rman is chopped\u00c3\u201a\u00c2\u00a0liver",
                    "verb":"<reply>"
                }
            ],
            "binder":[
                {
                    "id":"343",
                    "tidbit":"awesom",
                    "verb":"is"
                },
                {
                    "id":"344",
                    "tidbit":"awesome",
                    "verb":"is"
                }
            ],
            "bird":[
                {
                    "id":"291",
                    "tidbit":"the word",
                    "verb":"is"
                }
            ],
            "bomb":[
                {
                    "id":"352",
                    "tidbit":"http://aybabtu-khan.ytmnd.com/",
                    "verb":"is"
                }
            ],
            "bonder":[
                {
                    "id":"322",
                    "tidbit":"an imposter",
                    "verb":"is"
                }
            ],
            "bonder quotes":[
                {
                    "id":"330",
                    "tidbit":"* bonder drops a boot to the head in exchange for a boot to the head and takes a boot to the head in exchange for a boot to the head.",
                    "verb":"<reply>"
                },
                {
                    "id":"379",
                    "tidbit":"* bonder now contains a nice ass-car.",
                    "verb":"<reply>"
                },
                {
                    "id":"389",
                    "tidbit":"<bonder> it's a table with a huge ass-name",
                    "verb":"<reply>"
                }
            ],
            "boo":[
                {
                    "id":"303",
                    "tidbit":"jeers",
                    "verb":"<action>"
                }
            ],
            "boogies":[
                {
                    "id":"280",
                    "tidbit":"woogies",
                    "verb":"<action>"
                }
            ],
            "bugs":[
                {
                    "id":"166",
                    "tidbit":"http://cheezburger.com/View/4965719040",
                    "verb":"are"
                }
            ],
            "but thanks":[
                {
                    "id":"142",
                    "tidbit":"thanks $who's butt",
                    "verb":"<action>"
                }
            ],
            "captain":[
                {
                    "id":"346",
                    "tidbit":"http://picard.ytmnd.com/",
                    "verb":"is"
                },
                {
                    "id":"349",
                    "tidbit":"http://www.youtube.com/watch?v=6rYhRqf757I",
                    "verb":"is"
                }
            ],
            "cat":[
                {
                    "id":"351",
                    "tidbit":"http://www.youtube.com/watch?v=QH2-TGUlwu4",
                    "verb":"is"
                }
            ],
            "checkin":[
                {
                    "id":"73",
                    "tidbit":"How To Ruin An Automated Smoke Test.docx",
                    "verb":"<reply>"
                }
            ],
            "claps":[
                {
                    "id":"206",
                    "tidbit":"slow claps and rolls his eyes at $who",
                    "verb":"<action>"
                }
            ],
            "Coffee Creatures":[
                {
                    "id":"53",
                    "tidbit":"a band",
                    "verb":"is"
                }
            ],
            "dance":[
                {
                    "id":"164",
                    "tidbit":"does the sheefle shoffle!",
                    "verb":"<action>"
                },
                {
                    "id":"165",
                    "tidbit":"does a jig",
                    "verb":"<action>"
                },
                {
                    "id":"160",
                    "tidbit":"does a jig",
                    "verb":"<action>"
                },
                {
                    "id":"163",
                    "tidbit":"does the sheefle shoffle!",
                    "verb":"<action>"
                }
            ],
            "DB_Redesigner quotes":[
                {
                    "id":"361",
                    "tidbit":"<DB_Redesigner> I don't even rank",
                    "verb":"<reply>"
                },
                {
                    "id":"362",
                    "tidbit":"<DB_Redesigner> I rank slightly higher than some of the trivial comments!",
                    "verb":"<reply>"
                }
            ],
            "do something":[
                {
                    "id":"140",
                    "tidbit":"$verbs a $noun",
                    "verb":"<action>"
                },
                {
                    "id":"192",
                    "tidbit":"I only $verb $noun on $weekdays",
                    "verb":"<reply>"
                }
            ],
            "don't know":[
                {
                    "id":"7",
                    "tidbit":"A thousand apologies, effendi, but I do not understand.",
                    "verb":"<reply>"
                },
                {
                    "id":"8",
                    "tidbit":"Beeeeeeeeeeeeep!",
                    "verb":"<reply>"
                },
                {
                    "id":"9",
                    "tidbit":"Can't talk, zombies!",
                    "verb":"<reply>"
                },
                {
                    "id":"10",
                    "tidbit":"Error 42: Factoid not in database.  Please contact administrator of current universe.",
                    "verb":"<reply>"
                },
                {
                    "id":"12",
                    "tidbit":"I cannot access that data.",
                    "verb":"<reply>"
                },
                {
                    "id":"13",
                    "tidbit":"I do not know.",
                    "verb":"<reply>"
                },
                {
                    "id":"14",
                    "tidbit":"I don't know",
                    "verb":"<reply>"
                },
                {
                    "id":"15",
                    "tidbit":"I don't know anything about that.",
                    "verb":"<reply>"
                },
                {
                    "id":"16",
                    "tidbit":"I'm sorry, there's currently nothing associated with that keyphrase.",
                    "verb":"<reply>"
                },
                {
                    "id":"17",
                    "tidbit":"Not a bloody clue, sir.",
                    "verb":"<reply>"
                },
                {
                    "id":"18",
                    "tidbit":"UNCAUGHT EXCEPTION: TERMINATING",
                    "verb":"<reply>"
                },
                {
                    "id":"312",
                    "tidbit":"Error at 0x08: Reference not found",
                    "verb":"<reply>"
                }
            ],
            "drops item":[
                {
                    "id":"19",
                    "tidbit":"fumbles and drops $giveitem.",
                    "verb":"<action>"
                }
            ],
            "duplicate item":[
                {
                    "id":"20",
                    "tidbit":"$who: I already have $item.",
                    "verb":"<reply>"
                },
                {
                    "id":"21",
                    "tidbit":"But I've already got $item!",
                    "verb":"<reply>"
                },
                {
                    "id":"22",
                    "tidbit":"I already have $item.",
                    "verb":"<reply>"
                },
                {
                    "id":"23",
                    "tidbit":"No thanks, $who, I've already got one.",
                    "verb":"<reply>"
                }
            ],
            "dying":[
                {
                    "id":"74",
                    "tidbit":"How do you living beings cope with mortality?",
                    "verb":"<reply>"
                }
            ],
            "El Tecturans":[
                {
                    "id":"52",
                    "tidbit":"a band",
                    "verb":"is"
                }
            ],
            "ELB":[
                {
                    "id":"121",
                    "tidbit":"Ye Olde Elecktronicke Logge Booke",
                    "verb":"is"
                }
            ],
            "error":[
                {
                    "id":"313",
                    "tidbit":"Error 402, Payment Required",
                    "verb":"<reply>"
                },
                {
                    "id":"314",
                    "tidbit":"Error 418, I'm a Teapot",
                    "verb":"<reply>"
                },
                {
                    "id":"315",
                    "tidbit":"Error 420, Enhance your calm",
                    "verb":"<reply>"
                },
                {
                    "id":"316",
                    "tidbit":"Error 404, Not Found",
                    "verb":"<reply>"
                }
            ],
            "exquisite":[
                {
                    "id":"355",
                    "tidbit":"http://www.roflcat.com/images/cats/Exquisite.jpg",
                    "verb":"is"
                }
            ],
            "facepalm":[
                {
                    "id":"93",
                    "tidbit":"!facepalm",
                    "verb":"<reply>"
                },
                {
                    "id":"94",
                    "tidbit":"sigh",
                    "verb":"<reply>"
                },
                {
                    "id":"95",
                    "tidbit":"other_peoples_junk--",
                    "verb":"<reply>"
                }
            ],
            "fish":[
                {
                    "id":"249",
                    "tidbit":"friends",
                    "verb":"are"
                }
            ],
            "flip a coin":[
                {
                    "id":"119",
                    "tidbit":"heads",
                    "verb":"<reply>"
                },
                {
                    "id":"120",
                    "tidbit":"tails",
                    "verb":"<reply>"
                }
            ],
            "freak out":[
                {
                    "id":"144",
                    "tidbit":"Le Freak, C'est Chic",
                    "verb":"<reply>"
                }
            ],
            "ftw":[
                {
                    "id":"162",
                    "tidbit":"#winning",
                    "verb":"<reply>"
                }
            ],
            "FTW Your Face":[
                {
                    "id":"85",
                    "tidbit":"a band name",
                    "verb":"is"
                }
            ],
            "gbarta":[
                {
                    "id":"34",
                    "tidbit":"cool",
                    "verb":"is"
                }
            ],
            "gbarta quotes":[
                {
                    "id":"244",
                    "tidbit":"* gbarta considers suggesting a group hug....",
                    "verb":"<reply>"
                },
                {
                    "id":"245",
                    "tidbit":"<gbarta> process process process process process process process process process process process process process process process process process fail",
                    "verb":"<reply>"
                },
                {
                    "id":"285",
                    "tidbit":"<gbarta> I'm just going ot stick with open source, where its all the same without the counting the money part",
                    "verb":"<reply>"
                },
                {
                    "id":"286",
                    "tidbit":"<gbarta> Typical Microsoft tech, first they bait, then they hook, then they watch you being tormented by the technology while they kick back and laugh like mad men and count the money you gave them",
                    "verb":"<reply>"
                },
                {
                    "id":"340",
                    "tidbit":"<gbarta> I'll keep swatting at the escalation monkey :)",
                    "verb":"<reply>"
                },
                {
                    "id":"364",
                    "tidbit":"<gbarta> tell me Mr. 'ph0rman', what good is your 'CM' if you are unable to 'get the app running'",
                    "verb":"<reply>"
                },
                {
                    "id":"365",
                    "tidbit":"<gbarta> I think story is done then",
                    "verb":"<reply>"
                },
                {
                    "id":"406",
                    "tidbit":"<gbarta> time to cowboy up and check in :)",
                    "verb":"<reply>"
                },
                {
                    "id":"395",
                    "tidbit":"<gbarta> gate view still broky",
                    "verb":"<reply>"
                },
                {
                    "id":"407",
                    "tidbit":"<gbarta> I don't know why you guys keep complaining about meetings, I find them productive",
                    "verb":"<reply>"
                },
                {
                    "id":"442",
                    "tidbit":"<gbarta> In that case I'm going to go reason with starbucks",
                    "verb":"<reply>"
                }
            ],
            "graybeard":[
                {
                    "id":"358",
                    "tidbit":"tight",
                    "verb":"is"
                }
            ],
            "graybeard quotes":[
                {
                    "id":"284",
                    "tidbit":"<graybeard> your face is a retention site?",
                    "verb":"<reply>"
                },
                {
                    "id":"287",
                    "tidbit":"<graybeard> wiiroc is so last week",
                    "verb":"<reply>"
                },
                {
                    "id":"329",
                    "tidbit":"* graybeard 's ass is inherited",
                    "verb":"<reply>"
                },
                {
                    "id":"359",
                    "tidbit":"<graybeard> erotic exotic italians",
                    "verb":"<reply>"
                },
                {
                    "id":"360",
                    "tidbit":"<graybeard> when you get back, you'll want to wash",
                    "verb":"<reply>"
                },
                {
                    "id":"426",
                    "tidbit":"<graybeard> gettting my goove on",
                    "verb":"<reply>"
                }
            ],
            "grease":[
                {
                    "id":"305",
                    "tidbit":"the word",
                    "verb":"is"
                },
                {
                    "id":"306",
                    "tidbit":"the time",
                    "verb":"is"
                },
                {
                    "id":"307",
                    "tidbit":"the way",
                    "verb":"is"
                },
                {
                    "id":"308",
                    "tidbit":"the motion",
                    "verb":"is"
                },
                {
                    "id":"309",
                    "tidbit":"the way we are feeling",
                    "verb":"is"
                },
                {
                    "id":"310",
                    "tidbit":"the word that you heard",
                    "verb":"is"
                }
            ],
            "hail":[
                {
                    "id":"410",
                    "tidbit":"All Hail King Tooda!",
                    "verb":"<reply>"
                },
                {
                    "id":"411",
                    "tidbit":"Sieg Heil Tooda!",
                    "verb":"<reply>"
                },
                {
                    "id":"412",
                    "tidbit":"Oh Hail No!",
                    "verb":"<reply>"
                },
                {
                    "id":"413",
                    "tidbit":"Hail to the chef!",
                    "verb":"<reply>"
                },
                {
                    "id":"414",
                    "tidbit":"Hail, Hail, Rock-n-Roll",
                    "verb":"<reply>"
                },
                {
                    "id":"415",
                    "tidbit":"All hail, great master. Sir, hail! I come",
                    "verb":"<reply>"
                }
            ],
            "hawkeyes":[
                {
                    "id":"388",
                    "tidbit":"http://www.youtube.com/watch?v=l4ANP8g8wrE",
                    "verb":"is"
                }
            ],
            "hehe":[
                {
                    "id":"176",
                    "tidbit":"cackles maniacally",
                    "verb":"<action>"
                }
            ],
            "hello":[
                {
                    "id":"125",
                    "tidbit":"yo",
                    "verb":"<reply>"
                }
            ],
            "help":[
                {
                    "id":"183",
                    "tidbit":"I NEED SOMEBODY",
                    "verb":"<reply>"
                },
                {
                    "id":"185",
                    "tidbit":"NOT JUST ANYBODY",
                    "verb":"<reply>"
                },
                {
                    "id":"186",
                    "tidbit":"YOU KNOW I NEED SOMEONE, HELP!",
                    "verb":"<reply>"
                }
            ],
            "hey":[
                {
                    "id":"223",
                    "tidbit":"http://www.youtube.com/watch?v=iWw5YdW57Es",
                    "verb":"<reply>"
                },
                {
                    "id":"243",
                    "tidbit":"http://www.youtube.com/watch?v=6GggY4TEYbk",
                    "verb":"<reply>"
                }
            ],
            "hi":[
                {
                    "id":"429",
                    "tidbit":"http://www.youtube.com/watch?v=mGYpsNpg1bw",
                    "verb":"is"
                }
            ],
            "How old":[
                {
                    "id":"195",
                    "tidbit":"you?",
                    "verb":"are"
                }
            ],
            "humans":[
                {
                    "id":"68",
                    "tidbit":"kill all humans",
                    "verb":"<reply>"
                },
                {
                    "id":"86",
                    "tidbit":"greater than robots",
                    "verb":"are"
                },
                {
                    "id":"248",
                    "tidbit":"friends",
                    "verb":"are"
                }
            ],
            "i know right":[
                {
                    "id":"152",
                    "tidbit":"do we have any interest in that?",
                    "verb":"<reply>"
                }
            ],
            "I like it":[
                {
                    "id":"127",
                    "tidbit":"puts a ring on it",
                    "verb":"<action>"
                }
            ],
            "i love it when a plan comes together":[
                {
                    "id":"190",
                    "tidbit":"https://plus.google.com/101629211371073711149/posts/3Dt9H4W6BjJ",
                    "verb":"<reply>"
                }
            ],
            "ie6":[
                {
                    "id":"253",
                    "tidbit":"the suck",
                    "verb":"is"
                }
            ],
            "indeed":[
                {
                    "id":"110",
                    "tidbit":"hmmm... yes, quite",
                    "verb":"<reply>"
                }
            ],
            "insult":[
                {
                    "id":"234",
                    "tidbit":"$someone! Thou $insult1 $insult2 $insult3!",
                    "verb":"<reply>"
                }
            ],
            "insult manatee":[
                {
                    "id":"288",
                    "tidbit":"manatee! Thou $insult1 $insult2 $insult3!",
                    "verb":"<reply>"
                }
            ],
            "iowa":[
                {
                    "id":"418",
                    "tidbit":"iowa++",
                    "verb":"<reply>"
                },
                {
                    "id":"387",
                    "tidbit":"http://www.youtube.com/watch?v=l4ANP8g8wrE",
                    "verb":"is"
                },
                {
                    "id":"417",
                    "tidbit":"iowa--",
                    "verb":"<reply>"
                }
            ],
            "it":[
                {
                    "id":"89",
                    "tidbit":"certain",
                    "verb":"is"
                }
            ],
            "jamin quotes":[
                {
                    "id":"194",
                    "tidbit":"<jamin> IE6 can bite my seal",
                    "verb":"<reply>"
                }
            ],
            "kick":[
                {
                    "id":"78",
                    "tidbit":"Oh Yeah? I dare you to try that again!",
                    "verb":"<reply>"
                }
            ],
            "kids":[
                {
                    "id":"72",
                    "tidbit":"Have you ever tried just turning off the TV, sitting down with your children, and hitting them?",
                    "verb":"<reply>"
                }
            ],
            "kill someone":[
                {
                    "id":"99",
                    "tidbit":"uses $weapon on $someone causing over 9000 points damage.",
                    "verb":"<action>"
                },
                {
                    "id":"100",
                    "tidbit":"kills $someone",
                    "verb":"<action>"
                },
                {
                    "id":"112",
                    "tidbit":"turns CI and reports $who to the authorities",
                    "verb":"<action>"
                },
                {
                    "id":"116",
                    "tidbit":"$verbs $adjective $weapon $preposition $someone's $bodypart",
                    "verb":"<action>"
                }
            ],
            "know":[
                {
                    "id":"83",
                    "tidbit":"It's a Unix Machine!",
                    "verb":"<reply>"
                }
            ],
            "linux":[
                {
                    "id":"135",
                    "tidbit":"http://grooveshark.com/#/album/Pour+Some+Sugar+On+Me/3945117",
                    "verb":"<reply>"
                }
            ],
            "list items":[
                {
                    "id":"24",
                    "tidbit":"contains $inventory.",
                    "verb":"<action>"
                },
                {
                    "id":"25",
                    "tidbit":"I am carrying $inventory.",
                    "verb":"<reply>"
                },
                {
                    "id":"26",
                    "tidbit":"is carrying $inventory.",
                    "verb":"<action>"
                },
                {
                    "id":"50",
                    "tidbit":"a band",
                    "verb":"is"
                }
            ],
            "lol":[
                {
                    "id":"191",
                    "tidbit":"LOLCANO! https://plus.google.com/110388336699671082529/posts/bPmnD28eDge",
                    "verb":"<reply>"
                },
                {
                    "id":"230",
                    "tidbit":"lollerskates",
                    "verb":"<action>"
                },
                {
                    "id":"319",
                    "tidbit":"lollerblades",
                    "verb":"<action>"
                },
                {
                    "id":"419",
                    "tidbit":"aahahahahaahahahhhahahaaha",
                    "verb":"<reply>"
                },
                {
                    "id":"421",
                    "tidbit":"I CAN HAZ LOLS?",
                    "verb":"<reply>"
                },
                {
                    "id":"422",
                    "tidbit":"chuckles",
                    "verb":"<action>"
                },
                {
                    "id":"423",
                    "tidbit":"upchuckles",
                    "verb":"<action>"
                },
                {
                    "id":"427",
                    "tidbit":"lollygaggles",
                    "verb":"<action>"
                },
                {
                    "id":"428",
                    "tidbit":"lulz",
                    "verb":"<action>"
                }
            ],
            "longcat":[
                {
                    "id":"96",
                    "tidbit":"long",
                    "verb":"is"
                },
                {
                    "id":"97",
                    "tidbit":"http://cache.ohinternet.com/images/5/5c/Longcat.jpg",
                    "verb":"is"
                }
            ],
            "love":[
                {
                    "id":"425",
                    "tidbit":"http://www.youtube.com/watch?v=JeRa3RtBiIU",
                    "verb":"<reply>"
                }
            ],
            "lurksia":[
                {
                    "id":"107",
                    "tidbit":"lurksia",
                    "verb":"is"
                }
            ],
            "mama":[
                {
                    "id":"182",
                    "tidbit":"JUST KILLED A MAN",
                    "verb":"<reply>"
                },
                {
                    "id":"184",
                    "tidbit":"OoooOoOooOOOOOO",
                    "verb":"<reply>"
                }
            ],
            "manatee quotes":[
                {
                    "id":"45",
                    "tidbit":"<manatee> Hey you bandchucks! Quit chuckin' my band!",
                    "verb":"<reply>"
                },
                {
                    "id":"87",
                    "tidbit":"<manatee> Hey you reasonchucks! Quit chuckin' my reason!",
                    "verb":"<reply>"
                },
                {
                    "id":"92",
                    "tidbit":"<manatee> Hey you a-chucks! Quit chuckin' my a!",
                    "verb":"<reply>"
                },
                {
                    "id":"131",
                    "tidbit":"<manatee> I'll crucible your face",
                    "verb":"<reply>"
                }
            ],
            "meow":[
                {
                    "id":"350",
                    "tidbit":"http://www.youtube.com/watch?v=QH2-TGUlwu4",
                    "verb":"is"
                }
            ],
            "nerdrage":[
                {
                    "id":"111",
                    "tidbit":"if you think that's bad, get a load of this! http://i.imgur.com/8wedD.jpg",
                    "verb":"<reply>"
                },
                {
                    "id":"233",
                    "tidbit":"RAAAAAAAAAAAAAAAAAAGE! http://i.imgur.com/Qn129.jpg",
                    "verb":"<reply>"
                }
            ],
            "never gonna":[
                {
                    "id":"214",
                    "tidbit":"give you up",
                    "verb":"<reply>"
                },
                {
                    "id":"215",
                    "tidbit":"let you down",
                    "verb":"<reply>"
                },
                {
                    "id":"216",
                    "tidbit":"turn around, and hurt you",
                    "verb":"<reply>"
                }
            ],
            "nods":[
                {
                    "id":"188",
                    "tidbit":"concurs",
                    "verb":"<action>"
                }
            ],
            "nom":[
                {
                    "id":"171",
                    "tidbit":"cogito ergo yum",
                    "verb":"<reply>"
                }
            ],
            "nyan":[
                {
                    "id":"380",
                    "tidbit":"http://nyan.cat/",
                    "verb":"is"
                }
            ],
            "oh no":[
                {
                    "id":"143",
                    "tidbit":"GOT TO KEEP ON MOVING",
                    "verb":"<reply>"
                }
            ],
            "onetectooda":[
                {
                    "id":"268",
                    "tidbit":"cool",
                    "verb":"is"
                },
                {
                    "id":"320",
                    "tidbit":"onetectooda loves apple",
                    "verb":"<reply>"
                }
            ],
            "onetectooda quotes":[
                {
                    "id":"263",
                    "tidbit":"<onetectooda> oh ok, ph0rman++ for great name",
                    "verb":"<reply>"
                },
                {
                    "id":"341",
                    "tidbit":"<onetectooda> \"Look, I'm an engineer. I don't have time for a girlfriend, but a talking frog - now that's cool.\"",
                    "verb":"<reply>"
                },
                {
                    "id":"290",
                    "tidbit":"<onetectooda> that's a great word... jiggled.",
                    "verb":"<reply>"
                },
                {
                    "id":"396",
                    "tidbit":"<onetectooda> there's good stuff in there, and deep fried vegetable balls",
                    "verb":"<reply>"
                },
                {
                    "id":"385",
                    "tidbit":"* onetectooda jerks a tear",
                    "verb":"<reply>"
                },
                {
                    "id":"394",
                    "tidbit":"<onetectooda> don't over-elb this thing",
                    "verb":"<reply>"
                },
                {
                    "id":"420",
                    "tidbit":"<onetectooda> Mike Haildeman",
                    "verb":"<reply>"
                }
            ],
            "onetectooda's computer":[
                {
                    "id":"265",
                    "tidbit":"ridonculous",
                    "verb":"is"
                }
            ],
            "onetime":[
                {
                    "id":"281",
                    "tidbit":"teh suck",
                    "verb":"is"
                }
            ],
            "ore":[
                {
                    "id":"63",
                    "tidbit":"grey with yellow speckles",
                    "verb":"is"
                }
            ],
            "pen":[
                {
                    "id":"98",
                    "tidbit":"The pen is $color",
                    "verb":"<reply>"
                }
            ],
            "ph0rage quotes":[
                {
                    "id":"304",
                    "tidbit":"<ph0rage> happiness is a sleeping baby",
                    "verb":"<reply>"
                }
            ],
            "ph0rman":[
                {
                    "id":"66",
                    "tidbit":"who in the what now?",
                    "verb":"<reply>"
                },
                {
                    "id":"333",
                    "tidbit":"chopped liver",
                    "verb":"is"
                }
            ],
            "ph0rman quotes":[
                {
                    "id":"366",
                    "tidbit":"<ph0rman> I'll gbarta++ your face",
                    "verb":"<reply>"
                },
                {
                    "id":"108",
                    "tidbit":"<ph0rman> ukulele is so hip these days ;)",
                    "verb":"<reply>"
                },
                {
                    "id":"240",
                    "tidbit":"<ph0rman> onetectooda++ for being a zucchini face",
                    "verb":"<reply>"
                },
                {
                    "id":"328",
                    "tidbit":"<ph0rman> strongly typed my ass!",
                    "verb":"<reply>"
                },
                {
                    "id":"336",
                    "tidbit":"<ph0rman> wow, that's a whole lot of pony droppings",
                    "verb":"<reply>"
                },
                {
                    "id":"338",
                    "tidbit":"<ph0rman> we are the crushers of dreams",
                    "verb":"<reply>"
                },
                {
                    "id":"363",
                    "tidbit":"* ph0rman makes sure he has pants on",
                    "verb":"<reply>"
                },
                {
                    "id":"397",
                    "tidbit":"<ph0rman> <onetectooda> don't over-elb this thing",
                    "verb":"<reply>"
                },
                {
                    "id":"383",
                    "tidbit":"<ph0rman> i don't thin",
                    "verb":"<reply>"
                }
            ],
            "picard":[
                {
                    "id":"345",
                    "tidbit":"http://picard.ytmnd.com/",
                    "verb":"is"
                },
                {
                    "id":"348",
                    "tidbit":"http://www.youtube.com/watch?v=6rYhRqf757I",
                    "verb":"is"
                }
            ],
            "pickup full":[
                {
                    "id":"27",
                    "tidbit":"drops $giveitem and takes $item.",
                    "verb":"<action>"
                },
                {
                    "id":"28",
                    "tidbit":"hands $who $giveitem in exchange for $item",
                    "verb":"<action>"
                },
                {
                    "id":"29",
                    "tidbit":"is now carrying $item, but dropped $giveitem.",
                    "verb":"<action>"
                }
            ],
            "PikaJim":[
                {
                    "id":"35",
                    "tidbit":"cool",
                    "verb":"is"
                },
                {
                    "id":"55",
                    "tidbit":"a tertiary auditor to section seven three",
                    "verb":"is"
                }
            ],
            "ping":[
                {
                    "id":"298",
                    "tidbit":"pong",
                    "verb":"<reply>"
                }
            ],
            "pizza":[
                {
                    "id":"273",
                    "tidbit":"pizza is good cold",
                    "verb":"<reply>"
                },
                {
                    "id":"274",
                    "tidbit":"onetectooda",
                    "verb":"<reply>"
                },
                {
                    "id":"275",
                    "tidbit":"pizza is best served cold",
                    "verb":"<reply>"
                }
            ],
            "ponies":[
                {
                    "id":"335",
                    "tidbit":"http://spockisnotimpressed.tumblr.com/image/10181637185",
                    "verb":"are"
                }
            ],
            "Pony Boy and the Barts":[
                {
                    "id":"51",
                    "tidbit":"a band",
                    "verb":"is"
                }
            ],
            "problem":[
                {
                    "id":"70",
                    "tidbit":"Like most of life's problems, this one can be solved with bending.",
                    "verb":"<reply>"
                }
            ],
            "problems":[
                {
                    "id":"69",
                    "tidbit":"solved with bending",
                    "verb":"are"
                }
            ],
            "quiet":[
                {
                    "id":"168",
                    "tidbit":"http://engrishfunny.files.wordpress.com/2011/07/engrish-funny-quieting-only.jpg",
                    "verb":"<reply>"
                }
            ],
            "quiet in here":[
                {
                    "id":"153",
                    "tidbit":"crickets",
                    "verb":"<action>"
                }
            ],
            "rage":[
                {
                    "id":"369",
                    "tidbit":"KHAAAAAAAAAAAAAAAAAAAN!!!!!!!!!!!!!!",
                    "verb":"<reply>"
                }
            ],
            "Ravi":[
                {
                    "id":"36",
                    "tidbit":"cool",
                    "verb":"is"
                },
                {
                    "id":"37",
                    "tidbit":"cool?",
                    "verb":"is"
                }
            ],
            "really":[
                {
                    "id":"77",
                    "tidbit":"Yeah, I know, right?",
                    "verb":"<reply>"
                }
            ],
            "Revenge is a dish best served cold":[
                {
                    "id":"198",
                    "tidbit":"KHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAN!",
                    "verb":"<reply>"
                }
            ],
            "review":[
                {
                    "id":"132",
                    "tidbit":"I'll crucible your face",
                    "verb":"<reply>"
                }
            ],
            "right":[
                {
                    "id":"150",
                    "tidbit":"left",
                    "verb":"<reply>"
                }
            ],
            "rofl":[
                {
                    "id":"156",
                    "tidbit":"roffles his waffle",
                    "verb":"<action>"
                },
                {
                    "id":"157",
                    "tidbit":"http://ohinternet.com/ROFLCOPTER",
                    "verb":"is"
                }
            ],
            "score":[
                {
                    "id":"202",
                    "tidbit":"!score --high",
                    "verb":"<reply>"
                },
                {
                    "id":"203",
                    "tidbit":"!score $who",
                    "verb":"<reply>"
                },
                {
                    "id":"204",
                    "tidbit":"!score $someone",
                    "verb":"<reply>"
                }
            ],
            "scrum":[
                {
                    "id":"175",
                    "tidbit":"SKR0M!!!",
                    "verb":"<reply>"
                }
            ],
            "secret":[
                {
                    "id":"134",
                    "tidbit":"http://www.zeldainformer.com/images/news/zelda_secret_to_everybody.jpg",
                    "verb":"is"
                }
            ],
            "sigh":[
                {
                    "id":"122",
                    "tidbit":"fires up the wahmbulance",
                    "verb":"<action>"
                },
                {
                    "id":"130",
                    "tidbit":"cries $who a river",
                    "verb":"<action>"
                }
            ],
            "sighs":[
                {
                    "id":"238",
                    "tidbit":"le sigh",
                    "verb":"<reply>"
                }
            ],
            "siksia":[
                {
                    "id":"33",
                    "tidbit":"cool",
                    "verb":"is"
                },
                {
                    "id":"272",
                    "tidbit":"sir siksia the snazzy",
                    "verb":"is"
                },
                {
                    "id":"255",
                    "tidbit":"sick",
                    "verb":"is"
                },
                {
                    "id":"257",
                    "tidbit":"clutch",
                    "verb":"is"
                },
                {
                    "id":"258",
                    "tidbit":"rad",
                    "verb":"is"
                },
                {
                    "id":"259",
                    "tidbit":"wicked",
                    "verb":"is"
                },
                {
                    "id":"260",
                    "tidbit":"bad",
                    "verb":"is"
                },
                {
                    "id":"261",
                    "tidbit":"tight",
                    "verb":"is"
                },
                {
                    "id":"262",
                    "tidbit":"all that and a bag of chips",
                    "verb":"is"
                }
            ],
            "siksia quotes":[
                {
                    "id":"324",
                    "tidbit":"* siksia is A mechanism for connecting and disconnecting a vehicle engine from its transmission system",
                    "verb":"<reply>"
                },
                {
                    "id":"391",
                    "tidbit":"<siksia> bonder, forget that",
                    "verb":"<reply>"
                },
                {
                    "id":"409",
                    "tidbit":"<siksia> The King is dead! Long live the King!",
                    "verb":"<reply>"
                },
                {
                    "id":"424",
                    "tidbit":"* siksia his waffle",
                    "verb":"<reply>"
                }
            ],
            "sky":[
                {
                    "id":"62",
                    "tidbit":"blue",
                    "verb":"is"
                }
            ],
            "sleep":[
                {
                    "id":"139",
                    "tidbit":"dreams of $adjective $noun",
                    "verb":"<action>"
                }
            ],
            "so's your face":[
                {
                    "id":"177",
                    "tidbit":"FACE!",
                    "verb":"<reply>"
                }
            ],
            "something":[
                {
                    "id":"101",
                    "tidbit":"My, what a $adjective $noun!",
                    "verb":"<reply>"
                }
            ],
            "spider":[
                {
                    "id":"56",
                    "tidbit":"http://i.imgur.com/JnvS9.jpg",
                    "verb":"is"
                }
            ],
            "squirrel":[
                {
                    "id":"64",
                    "tidbit":"cowers in fear",
                    "verb":"<action>"
                }
            ],
            "stampy":[
                {
                    "id":"65",
                    "tidbit":"runs for the hills",
                    "verb":"<action>"
                },
                {
                    "id":"118",
                    "tidbit":"!stampy",
                    "verb":"<reply>"
                }
            ],
            "stop":[
                {
                    "id":"270",
                    "tidbit":"HAMMER TIME!",
                    "verb":"<reply>"
                }
            ],
            "sure":[
                {
                    "id":"81",
                    "tidbit":"true, true",
                    "verb":"<reply>"
                }
            ],
            "takes item":[
                {
                    "id":"30",
                    "tidbit":"is now carrying $item.",
                    "verb":"<action>"
                },
                {
                    "id":"31",
                    "tidbit":"now contains $item.",
                    "verb":"<action>"
                },
                {
                    "id":"32",
                    "tidbit":"Okay, $who.",
                    "verb":"<reply>"
                }
            ],
            "Team++":[
                {
                    "id":"91",
                    "tidbit":"cool",
                    "verb":"is"
                }
            ],
            "the":[
                {
                    "id":"79",
                    "tidbit":"who the?",
                    "verb":"<reply>"
                }
            ],
            "the correct statement there":[
                {
                    "id":"300",
                    "tidbit":"\"I'll drink FROM that!\"",
                    "verb":"is"
                }
            ],
            "tldr":[
                {
                    "id":"229",
                    "tidbit":"http://i.imgur.com/4vLJk.gif",
                    "verb":"<reply>"
                }
            ],
            "trade":[
                {
                    "id":"106",
                    "tidbit":"trades $who for $newitem in exchange for $item",
                    "verb":"<action>"
                }
            ],
            "trunk":[
                {
                    "id":"71",
                    "tidbit":"Stampy who? where?",
                    "verb":"<reply>"
                }
            ],
            "unit tests":[
                {
                    "id":"80",
                    "tidbit":"Pass all unit tests",
                    "verb":"<reply>"
                }
            ],
            "unix":[
                {
                    "id":"90",
                    "tidbit":"I know this!",
                    "verb":"<reply>"
                }
            ],
            "watch":[
                {
                    "id":"146",
                    "tidbit":"privates eyes [CLAP] are watching you [CLAPCLAP]",
                    "verb":"<reply>"
                }
            ],
            "watching":[
                {
                    "id":"149",
                    "tidbit":"privates eyes [CLAP] are watching you [CLAPCLAP]",
                    "verb":"<reply>"
                }
            ],
            "water":[
                {
                    "id":"61",
                    "tidbit":"wet",
                    "verb":"is"
                }
            ],
            "waves":[
                {
                    "id":"161",
                    "tidbit":"parabolas",
                    "verb":"<action>"
                },
                {
                    "id":"404",
                    "tidbit":"tangents",
                    "verb":"<action>"
                },
                {
                    "id":"402",
                    "tidbit":"sines",
                    "verb":"<action>"
                },
                {
                    "id":"403",
                    "tidbit":"cosines",
                    "verb":"<action>"
                }
            ],
            "what":[
                {
                    "id":"47",
                    "tidbit":"you talking about?",
                    "verb":"are"
                },
                {
                    "id":"172",
                    "tidbit":"you?",
                    "verb":"are"
                },
                {
                    "id":"196",
                    "tidbit":"cool?",
                    "verb":"is"
                },
                {
                    "id":"282",
                    "tidbit":"heads?",
                    "verb":"is"
                },
                {
                    "id":"250",
                    "tidbit":"you carrying?",
                    "verb":"are"
                },
                {
                    "id":"283",
                    "tidbit":"an LSSP?",
                    "verb":"is"
                },
                {
                    "id":"289",
                    "tidbit":"yeahwhatever",
                    "verb":"<reply>"
                }
            ],
            "what are we going to do today":[
                {
                    "id":"123",
                    "tidbit":"The same thing we do every day, $who; try to take over the world.",
                    "verb":"<reply>"
                }
            ],
            "what do you think":[
                {
                    "id":"279",
                    "tidbit":"I think it's stupid and I hate your face",
                    "verb":"<reply>"
                }
            ],
            "what is that":[
                {
                    "id":"129",
                    "tidbit":"Look at that thing! No that other thing!",
                    "verb":"<reply>"
                }
            ],
            "what is this":[
                {
                    "id":"128",
                    "tidbit":"I don't even",
                    "verb":"<reply>"
                }
            ],
            "who":[
                {
                    "id":"48",
                    "tidbit":"cool?",
                    "verb":"is"
                }
            ],
            "whoa":[
                {
                    "id":"174",
                    "tidbit":"http://i.imgur.com/nvOjD.gif",
                    "verb":"is"
                }
            ],
            "why":[
                {
                    "id":"269",
                    "tidbit":"that my problem?",
                    "verb":"is"
                }
            ],
            "windows":[
                {
                    "id":"126",
                    "tidbit":"Roses are red, violets are blue - as you can guess, my screen is, too.",
                    "verb":"<reply>"
                }
            ],
            "word":[
                {
                    "id":"232",
                    "tidbit":"palabra a tu madre",
                    "verb":"<reply>"
                },
                {
                    "id":"292",
                    "tidbit":"b-b-b-bird, bird, bird, bird is the word",
                    "verb":"<reply>"
                },
                {
                    "id":"295",
                    "tidbit":"everybody knows that the bird is the word",
                    "verb":"<reply>"
                },
                {
                    "id":"296",
                    "tidbit":"have you heard about the word?",
                    "verb":"<reply>"
                }
            ],
            "wtf":[
                {
                    "id":"170",
                    "tidbit":"please ask manatee",
                    "verb":"<reply>"
                },
                {
                    "id":"323",
                    "tidbit":"http://cheezburger.com/5420156928",
                    "verb":"<reply>"
                }
            ],
            "yay":[
                {
                    "id":"302",
                    "tidbit":"cheers",
                    "verb":"<action>"
                },
                {
                    "id":"405",
                    "tidbit":"looks for ponies",
                    "verb":"<action>"
                }
            ],
            "yes Ravi":[
                {
                    "id":"46",
                    "tidbit":"cool",
                    "verb":"is"
                }
            ],
            "your face":[
                {
                    "id":"200",
                    "tidbit":"a longcat",
                    "verb":"is"
                },
                {
                    "id":"209",
                    "tidbit":"really $who, really? a face joke? sigh.",
                    "verb":"<reply>"
                },
                {
                    "id":"210",
                    "tidbit":"your face is a $noun",
                    "verb":"<reply>"
                },
                {
                    "id":"212",
                    "tidbit":"$verbs $who's face",
                    "verb":"<action>"
                }
            ],
            "your mission":[
                {
                    "id":"59",
                    "tidbit":"kill all humans",
                    "verb":"is"
                }
            ]
        },
        "items":[
            {
                "id":"1",
                "item":"the Creature"
            },
            {
                "id":"2",
                "item":"two turtle doves"
            },
            {
                "id":"3",
                "item":"three french hens"
            },
            {
                "id":"4",
                "item":"four calling birds"
            },
            {
                "id":"5",
                "item":"five golden rings"
            },
            {
                "id":"6",
                "item":"six geese a-laying"
            },
            {
                "id":"7",
                "item":"seven swans a-swimming"
            },
            {
                "id":"8",
                "item":"eight maids a-milking"
            },
            {
                "id":"9",
                "item":"nine ladies dancing"
            },
            {
                "id":"10",
                "item":"a comeback"
            },
            {
                "id":"11",
                "item":"a nice ass-car"
            },
            {
                "id":"12",
                "item":"the root password"
            },
            {
                "id":"13",
                "item":"a dirty bucket"
            },
            {
                "id":"14",
                "item":"a magic wand"
            },
            {
                "id":"15",
                "item":"a headcrab"
            },
            {
                "id":"16",
                "item":"42 hikers a-hitching"
            },
            {
                "id":"17",
                "item":"a face"
            },
            {
                "id":"18",
                "item":"a foosball"
            },
            {
                "id":"19",
                "item":"a unit test"
            },
            {
                "id":"20",
                "item":"a manatee"
            },
            {
                "id":"21",
                "item":"an integration test"
            },
            {
                "id":"22",
                "item":"sheep and a wheat"
            },
            {
                "id":"23",
                "item":"a stampy"
            },
            {
                "id":"24",
                "item":"siksia's marbles"
            },
            {
                "id":"25",
                "item":"a free coffee"
            },
            {
                "id":"26",
                "item":"a hug"
            },
            {
                "id":"27",
                "item":"a disease-ridden syringe"
            },
            {
                "id":"28",
                "item":"a stone, a wheat, and a sheep"
            },
            {
                "id":"29",
                "item":"a stone axe"
            },
            {
                "id":"30",
                "item":"a sack of spiders"
            },
            {
                "id":"31",
                "item":"a swift kick to the face"
            },
            {
                "id":"32",
                "item":"a couple of ibuprofin"
            },
            {
                "id":"33",
                "item":"a couple of ibuprofen"
            },
            {
                "id":"34",
                "item":"secret sauce"
            },
            {
                "id":"35",
                "item":"some post-screamo neofunkcore"
            },
            {
                "id":"36",
                "item":"elb"
            },
            {
                "id":"37",
                "item":"a roflcopter"
            },
            {
                "id":"38",
                "item":"some mutton"
            },
            {
                "id":"39",
                "item":"some lettuce"
            },
            {
                "id":"40",
                "item":"some tomato"
            },
            {
                "id":"41",
                "item":"the cold shoulder"
            },
            {
                "id":"42",
                "item":"Snook's face"
            },
            {
                "id":"43",
                "item":"a band-chuck"
            },
            {
                "id":"44",
                "item":"some coffee"
            },
            {
                "id":"45",
                "item":"ph0rman's health potions"
            },
            {
                "id":"46",
                "item":"a health potion"
            },
            {
                "id":"47",
                "item":"a manna potion"
            },
            {
                "id":"48",
                "item":"a piece of trival loot"
            },
            {
                "id":"49",
                "item":"a beer"
            },
            {
                "id":"50",
                "item":"a dictionary for ph0rman"
            },
            {
                "id":"51",
                "item":"a jackwagon"
            },
            {
                "id":"52",
                "item":"a boot to the head"
            },
            {
                "id":"53",
                "item":"a ph0rman"
            },
            {
                "id":"54",
                "item":"3 french hens"
            },
            {
                "id":"55",
                "item":"the finger"
            },
            {
                "id":"56",
                "item":"a red stapler"
            },
            {
                "id":"57",
                "item":"a high five"
            },
            {
                "id":"58",
                "item":"a shiv to the gut"
            },
            {
                "id":"59",
                "item":"a ticking time-bomb"
            },
            {
                "id":"60",
                "item":"item for"
            },
            {
                "id":"61",
                "item":"another boot to the head"
            },
            {
                "id":"62",
                "item":"a Hail To Your Face"
            },
            {
                "id":"63",
                "item":"a fus ro dah"
            },
            {
                "id":"64",
                "item":"a cold shoulder"
            },
            {
                "id":"65",
                "item":"a wedgie"
            },
            {
                "id":"66",
                "item":"a chip on ph0rman's shoulder"
            },
            {
                "id":"67",
                "item":"a piece of ph0rman's mind"
            },
            {
                "id":"68",
                "item":"a pony"
            },
            {
                "id":"69",
                "item":"a verbose ph0rman"
            },
            {
                "id":"70",
                "item":"a mike to the face"
            },
            {
                "id":"71",
                "item":"a feral kitten"
            },
            {
                "id":"72",
                "item":"the finger back"
            },
            {
                "id":"73",
                "item":"some more nothing"
            },
            {
                "id":"74",
                "item":"a jar of CNAS"
            },
            {
                "id":"75",
                "item":"something"
            },
            {
                "id":"76",
                "item":"nothing"
            },
            {
                "id":"77",
                "item":"a fist bump"
            },
            {
                "id":"78",
                "item":"a helping hand"
            },
            {
                "id":"79",
                "item":"the last laugh"
            },
            {
                "id":"80",
                "item":"a bender"
            },
            {
                "id":"81",
                "item":"a bonder"
            },
            {
                "id":"83",
                "item":"a graybeard"
            },
            {
                "id":"97",
                "item":"a nothing"
            },
            {
                "id":"98",
                "item":"a finger"
            },
            {
                "id":"99",
                "item":"the word"
            },
            {
                "id":"102",
                "item":"a ring"
            },
            {
                "id":"106",
                "item":"some figgy pudding"
            },
            {
                "id":"116",
                "item":"a hand"
            },
            {
                "id":"117",
                "item":"up"
            },
            {
                "id":"119",
                "item":"a b"
            },
            {
                "id":"120",
                "item":"a i"
            },
            {
                "id":"121",
                "item":"a n"
            },
            {
                "id":"122",
                "item":"a d"
            },
            {
                "id":"123",
                "item":"a e"
            },
            {
                "id":"124",
                "item":"a r"
            },
            {
                "id":"127",
                "item":"noms"
            },
            {
                "id":"129",
                "item":"a fart"
            },
            {
                "id":"130",
                "item":"a table with a huge ass-name"
            },
            {
                "id":"139",
                "item":"a nothing in exchange for the word in exchange for a swift kick to the face in exchange for a face"
            }
        ],
        "vars":{
            "verb":{
                "type":"verb",
                "values":[                    "hug", "kiss", "listen", "run", "shriek", "sleep", "smash", "talk", "use", "walk"                ]
            },
            "noun":{
                "type":"noun",
                "values":[                    "acid", "acorn", "bacon", "battery", "beef", "cake", "comic", "device", "factoid", "galaxy", "idea", "magic", "mindjail", "phone", "potato", "salami", "shirt", "sword", "tooth", "wrench"                ]
            },
            "adjective":{
                "type":"var",
                "values":[                    "adorable", "cold", "fast", "fuzzy", "gigantic", "hairless", "hairy", "hot", "huge", "iridescent", "lukewarm", "moldy", "repulsive", "rough", "royal", "sharp", "shiny", "slow", "smelly", "smooth", "sparkly", "spicy", "spikey", "spooky", "squishy", "sticky", "tangy", "tiny", "warm", "windy", "wonky"                ]
            },
            "digit":{
                "type":"var",
                "values":[                    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"                ]
            },
            "preposition":{
                "type":"var",
                "values":[                    "across", "at", "behind", "between", "excluding", "in", "near", "on", "opposite", "over", "regarding", "under", "upon", "via", "within"                ]
            },
            "color":{
                "type":"var",
                "values":[                    "blue", "cerulean", "chartreuse", "indigo", "mahogany", "maroon", "octarine", "plum", "puce", "red", "saffron", "teal"                ]
            },
            "article":{
                "type":"var",
                "values":[                    "a", "the"                ]
            },
            "weekday":{
                "type":"noun",
                "values":[                    "Friday", "Monday", "Saturday", "Sunday", "Thursday", "Tuesday", "Wednesday"                ]
            },
            "band":{
                "type":"var",
                "values":[                    "alert inspector bizlogic", "Alpine Shark Attack", "away from openvpn", "bancomicsans is cool", "binder is awesome", "bl party today", "call or irc", "can we help", "Cant talk zombies", "coal creek pkwy", "cogito ergo yum", "could be stationgateposition", "crapitty crap crapper", "did you ride", "except exceptions excellently", "fish are friends", "for his triggers", "from outer space", "gbarta is cool", "gbarta kicking butt", "give you up", "googlefight andrew george", "googlefight ken ryu", "googlefight renton newcastle", "googlefight robb rob", "googlefight scrum waterfall", "hes dead jim", "hipstersia", "hmmm yes quite", "hows it going", "humans are friends", "I am beautiful", "I am dumb", "I am great", "I am obnixious", "I dont know", "I have TOAST", "I know this", "I mean bizlogic", "I NEED SOMEBODY", "i thought so", "in ASUS nonetheless", "Internet Robot Cats", "issue with totalTime", "it is certain", "just doing it", "kill all humans", "let you down", "Leta doing well", "lol just 2", "longcat is long", "maybe demo data", "moore has it", "no caching yet", "no time select", "NOT JUST ANYBODY", "not sure checking", "not the core", "not the face", "Oh Hail No", "oh only 4", "ok gotta go", "ok not all", "One Tectura Tradewinds", "onetectooda loves apple", "only in attitude", "only took 45min", "ouch bad speeling", "ph0rman hates spiders", "PikaJim is cool", "please ask manatee", "points all around", "push button scenario", "Ravi is cool", "reminiscent of phreaking", "siksia is clutch", "siksia is cool", "siksia is rad", "siksia is sick", "siksia is tight", "siksia is wicked", "since its new", "sky is blue", "so on hold", "Team is cool", "The Simple Sounds", "there is hope", "there we go", "theyre aircraft comments", "UNCAUGHT EXCEPTION TERMINATING", "very good movie", "water is wet", "we be jamin", "What are you", "what is cool", "what is heads", "who is cool", "why no work", "Wobbly Tunes", "works for me", "yeah fix that", "yeah thats right", "yeah working fine"                ]
            },
            "weapon":{
                "type":"noun",
                "values":[                    "crowbar", "maint log", "nunchucks", "running chainsaw", "sheep and a wheat", "spoon", "sword"                ]
            },
            "bodypart":{
                "type":"noun",
                "values":[                    "face", "foosball", "spleen"                ]
            },
            "insult1":{
                "type":"var",
                "values":[                    "artless", "bawdy", "beslubbering", "bootless", "churlish", "clouted", "cockered", "craven", "currish", "dankish", "dissembling", "droning", "errant", "fawning", "fobbing", "frothy", "froward", "gleeking", "goatish", "gorbellied", "impertinent", "infectious", "jarring", "loggerheaded", "lumpish", "mammering", "mangled", "mewling", "paunchy", "pribbling", "puking", "puny", "qualling", "rank", "reeky", "roguish", "ruttish", "saucy", "spleeny", "spongy", "surly", "tottering", "unmuzzled", "vain", "venomed", "villainous", "warped", "wayward", "weedy", "yeasty"                ]
            },
            "insult2":{
                "type":"var",
                "values":[                    "base-court", "bat-fowling", "beef-witted", "beetle-headed", "boil-brained", "clapper-clawed", "clay-brained", "common-kissing", "crook-pated", "dismal-dreaming", "dizzy-eyed", "doghearted", "dread-bolted", "earth-vexing", "elf-skinned", "fat-kidneyed", "fen-sucked", "flap-mouthed", "fly-bitten", "folly-fallen", "fool-born", "full-gorged", "guts-griping", "half-faced", "hasty-witted", "hedge-born", "hell-hated", "idle-headed", "ill-breeding", "ill-nurtured", "knotty-pated", "milk-livered", "motley-minded", "onion-eyed", "plume-plucked", "pottle-deep", "pox-marked", "reeling-ripe", "rough-hewn", "rude-growing", "rump-fed", "shard-borne", "sheep-biting", "spur-galled", "swag-bellied", "tardy-gaited", "tickle-brained", "toad-spotted", "unchin-snouted", "weather-bitten"                ]
            },
            "insult3":{
                "type":"var",
                "values":[                    "apple-john", "baggage", "barnacle", "bladder", "boar-pig", "bugbear", "bum-bailey", "canker-blossom", "clack-dish", "clotpole", "codpiece", "coxcomb", "death-token", "dewberry", "flap-dragon", "flax-wench", "flirt-gill", "foot-licker", "fustilarian", "giglet", "gudgeon", "haggard", "harpy", "hedge-pig", "horn-beast", "hugger-mugger", "joithead", "lewdster", "lout", "maggot-pie", "malt-worm", "mammet", "measle", "minnow", "miscreant", "moldwarp", "mumble-news", "nut-hook", "pigeon-egg", "pignut", "pumpion", "puttock", "ratsbane", "scut", "skainsmate", "strumpet", "varlot", "vassal", "wagtail", "whey-face"                ]
            }
        }
    }
    msg.send "DONE!"
