extends Node2D
@export var playernum = 1
@onready var main = $".."

var fishing = false
var reeling = false
var reeldelta = 1.0
var reelspeed = 100

var A = ""
var B = ""
var C = ""
func _ready():
	if playernum == 1:
		A = "a"
		B = "jump"
		C = "c"
	elif playernum == 2:
		A = "P2a"
		B = "P2jump"
		C = "P2c"
	
	await get_tree().create_timer(0.1).timeout
	cast()

func _input(_event):
	if Input.is_action_just_pressed(A) or Input.is_action_just_pressed(B) or Input.is_action_just_pressed(C):
		if fishing == true:
			if reeling == true:
				reel()
			else:
				badreel()

func cast():
	fishing = false
	$playersprite.play("cast")
	await $playersprite.animation_finished
	$playersprite.play("idle")
	await get_tree().create_timer(0.4).timeout
	fishing = true

func reel():
	var reelanival = 1 #this value is set by how accurate the input is
	$playersprite.play("reel" + str(reelanival))

func badreel():
	fishing = false
	var randnum = int(randi_range(1,2))
	$playersprite.play("reel" + str(randnum))
	await get_tree().create_timer(0.3).timeout
	$playersprite.play("idle")
	await get_tree().create_timer(0.2).timeout
	fishing = true
	
