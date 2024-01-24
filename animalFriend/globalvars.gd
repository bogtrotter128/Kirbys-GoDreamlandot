extends Node

var p
func _ready():
	if $"..".is_in_group("player1"):
		p = 1
	if $"..".is_in_group("player2"):
		p = 2

@export var dropfriend : PackedScene
var player1 = preload("res://player/player_1.tscn")
var player2 = preload("res://player/player_2.tscn")

var frenval = 1

func _input(_event):
	if Input.is_action_just_pressed($"..".C) && $"..".jumpCount < 1:
		await get_tree().create_timer(0.1).timeout
		dropanimalfriend()

func dropanimalfriend():
	var animalfriend = dropfriend.instantiate()
	var player
	if $"..".is_in_group("player1"):
		GameUtils.FRENVAL = 0
		player = player1.instantiate()
	if $"..".is_in_group("player2"):
		GameUtils.FRENVAL = 0
		player = player2.instantiate()
	animalfriend.frenval = frenval
	animalfriend.position = Vector2($"..".position.x,$"..".position.y - 2)
	player.position = Vector2($"..".position.x,$"..".position.y - 10)
	$"..".queue_free()
	$"..".call_deferred("add_sibling", player)
	$"..".call_deferred("add_sibling", animalfriend)
	#AND SUMMON THE PLAYER BACK

func _process(_delta):
	if p == 1:
		p1glob()
	if p == 2:
		p2glob()

func p1glob():
	#gets kirbys global position
	GameUtils.posX = $"..".global_position.x
	GameUtils.posY = $"..".global_position.y
	
	#global variable tracker
	GameUtils.DIR = $"..".DIR
	
	if GameUtils.SECONDPLAYER == true:
		GameUtils.MAXHP = 8
	else:
		GameUtils.MAXHP = 10
	
	if GameUtils.HEALTH > GameUtils.MAXHP:
		GameUtils.HEALTH = GameUtils.MAXHP
	
	if GameUtils.ABILITY > 0:
		$"..".hasAbility = true
	else:
		$"..".hasAbility = false
	#rules for when something enters kirby's mouth
#BEFORE swallowing
#after inhaling
	#mouthFull = true basically
	if GameUtils.mouthValue > 1:
		$"..".mouthFull = true
		$"..".jumpCount = $"..".jumpMax
		$"..".canInhale = false
		GameUtils.Killsuck = true

func p2glob():
	#gets kirbys global position
	GameUtils.posXP2 = $"..".global_position.x
	GameUtils.posYP2 = $"..".global_position.y
	
	#global variable tracker
	GameUtils.DIRP2 = $"..".DIR
	
	if GameUtils.HEALTHP2 > GameUtils.MAXHPP2:
		GameUtils.HEALTHP2 = GameUtils.MAXHPP2
	
	if GameUtils.ABILITYP2 > 0:
		$"..".hasAbility = true
	else:
		$"..".hasAbility = false
	#rules for when something enters kirby's mouth
#BEFORE swallowing
#after inhaling
	#mouthFull = true basically
	if GameUtils.mouthValueP2 > 1:
		$"..".mouthFull = true
		$"..".jumpCount = $"..".jumpMax
		$"..".canInhale = false
		GameUtils.Killsuck = true
