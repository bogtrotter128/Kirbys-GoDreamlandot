extends Node
#var that gets added to when a milestone is completed
var completionpercent = 0

#var that checks if gooey is present
var SECONDPLAYER = false
var opAbilities = false
#used for recall function
var firstplayerrecall = false
var secondplayerrecall = false
var RECALL = false
var CANRECALL = true
#this is kirbs HP
var HEALTH = 10
#this is goos HP
var HEALTHP2 = 8

#kirb's max hp (used for summoning player2, and reverting hp back afterwards)
var MAXHP = 10
var MAXHPP2 = 8
#these are the star points kirb has
var STARS = 0
# 1 ups
var SCORES1UP = 3

#this lets me change the max jumps depending on wherever its needed
var JUMPMAX = 999

#this is kirbs current copy ability (0 is nothing)
var ABILITY = 0
#this is the ability that is in kirbs mouth
var HELDABILITY = 0
#mouth value is 1, when it goes over 1, kirby swallows wahtever is in mouth
var mouthValue = 1
#id of the animal friend in use. 0 is none
var FRENVAL = 0

var ABILITYP2 = 0
var HELDABILITYP2 = 0
var mouthValueP2 = 1
var FRENVALP2 = 0

var enemyHP = 0
#kibs damage (this isnt really used)
var DAM = 1
#the direction kirb is facing
var DIR = 1
var DIRP2 = 1


#iframes
var Iframes = false
var IframesP2 = false

#player 1 positions these should be vectors but its too late now
var posX = 0
var posY = 0
#player 2 positions
var posXP2 = 0
var posYP2 = 0

#
var roomloaded = ""
#this is the number of hertstars collected
var HEARTSTARS = 0
#levelmax is the number of levels unlocked
var levelmax = 6
#levelval is the selected level
var levelval = 1

#the value represents the number of stages completed/aviable for lvel 1
var stageval1 = 1
#list of which heartstars collected in stage
var stage1HS = [true, false, false,false, false, false]

var stageval2 = 1
var stage2HS = [false, false, false,false, false, false]

var stageval3 = 1
var stage3HS = [false, false, false,false, false, false]

var stageval4 = 1
var stage4HS = [false, false, false,false, false, false]

var stageval5 = 1
var stage5HS = [false, false, false,false, false, false]

#minigame vars
#minigameval is the selected minigame
var minigameval = 1

var gofishscore1 = [0,0,0,0,0,0,0]
var gofishscore2 = [0,0,0,0,0,0,0]
var gofishunlock = [false, false, false,false,false]

var rushhiscore1 = [0,0.0,0,0.0,0,0.0,0,0.0,0,0.0,0,0.0]
var rushhiscore2 = [0,0.0,0,0.0,0,0.0,0,0.0,0,0.0,0,0.0]
var rushunlock = [false, false, false,false,false]

var egggamescore1 = [0,0,0,0,0,0,0]
var egggamescore2 = [0,0,0,0,0,0,0]

var blockballhiscore = [0,0,0,0,0,0]
var blockballunlock = [false, false, false,false,false]

var gourmetracetime1 = [0,0,0,0,0,0,0]
var gourmetracetime2 = [0,0,0,0,0,0,0]
var gourmetunlock = [false, false, false,false,false]

var arenascore = [1992,8892]
var arenatime = [120,30]
var truearenaunlocked = false
