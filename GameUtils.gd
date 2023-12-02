extends Node
#var that checks if gooey is present
var SECONDPLAYER = false
#this is kirbs HP
var HEALTH = 10
#this is goos HP
var HEALTHP2 = 8

#kirb's max hp (used for summoning player2, and reverting hp back afterwards)
var MAXHP = 10
var MAXHPP2 = 8
#these are the star points kirb has
var STARS = 0
#this is the number of hertstars collected
var HEARTSTARS

#this lets me change the max jumps depending on wherever its needed
#on the harder difficulty, it will be 1 or 3 jumps
var JUMPMAX = 999

#this is kirbs current copy ability (0 is nothing)
var ABILITY = 0
#this is the ability that is in kirbs mouth
var HELDABILITY = 0
#mouth value is 1, when it goes over 1, kirby swallows wahtever is in mouth
var mouthValue = 1

var ABILITYP2 = 0

var HELDABILITYP2 = 0

var mouthValueP2 = 1


var enemyHP = 0
#kibs damage (this isnt really used)
var DAM = 1
#the direction kirb is facing
var DIR = 1
var DIRP2 = 1


#iframes
var Iframes = false
var IframeHit = false

var IframesP2 = false
var IframeHitP2 = false

#this kills the inhale hitbox
var Killsuck = false
#kills the ability hitboxes
var KillAbility = false

var KillsuckP2 = false
var KillAbilityP2 = false
