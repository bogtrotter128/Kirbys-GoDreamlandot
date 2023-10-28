extends Node

#this is kirbs HP
var HEALTH = 10
#these are the star points kirb has
var STARS = 0
#this is the number of hertstars collected
var HEARTSTARS

#this is kirbs current copy ability (0 is nothing)
var ABILITY = 0
#this is the ability that is in kirbs mouth
var HELDABILITY = 0
#mouth value is 1, when it goes over 1, kirby swallows wahtever is in mouth
var mouthValue = 1


var enemyHP = 0
#kibs damage (this isnt really used)
var DAM = 1
#the direction kirb is facing
var DIR = 1
#iframes
var Iframes = false
var IframeHit = false

#this kills the inhale hitbox
var Killsuck = false
var Killflame = false
