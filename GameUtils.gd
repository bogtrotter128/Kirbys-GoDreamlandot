extends Node
#var that checks if gooey is present
var SECONDPLAYER = false
var opAbilities = false
#used for recall function
var firstplayerrecall = false
var secondplayerrecall = false
var RECALL = false
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
var JUMPMAX = 1

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


#lvel variables
var tempcollectablelist = []
#this is the number of hertstars collected
var HEARTSTARS = 0
#levelmax is the number of levels unlocked
var levelmax = 6
#levelval is the selected level
var levelval = 1
#the value represents the number of stages completed/aviable for lvel 1
var stageval1 = 1
#list of which heartstars collected in stage
var stage1HS = [false, false, false,false, false, false]

var stageval2 = 1
var stage2HS = [false, false, false,false, false, false]

var stageval3 = 1
var stage3HS= [false, false, false,false, false, false]

var stageval4 = 1
var stage4HS= [false, false, false,false, false, false]

var stageval5 = 1
var stage5HS= [false, false, false,false, false, false]

#minigame vars
var rushhiscore = [0,0.0,0,0.0,0,0.0,0,0.0,0,0.0,0,0.0]
var rushstagescore = [11,12,13,21,22,23,31,32,33,88] # 88 is endless mode, cause infinity 8

var blockballhiscore = [0,0,0,0,0,0]
var blockballstagescore = [11,12,13,14,15,21,22,23,24,25,31,32,33,34,35] #the stage scores ex.1-1, 2-1, 3-1
