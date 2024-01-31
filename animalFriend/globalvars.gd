extends Node

var p = 0
var candrop = true
var playerlist = [
	"res://player/player_1.tscn",
	"res://player/player_2.tscn"
]
func _ready():
	if $"..".is_in_group("player1"):
		p = 1
	if $"..".is_in_group("player2"):
		p = 2

func _input(_event):
	#calls the dropanimalfriend() func in the playerloadinscene.
	# which deletes the animalfriend and spawns back the player & idlefren
	if Input.is_action_just_pressed($"..".C) && $"..".is_jumping == false && p == 1 && candrop == true:
		candrop = false # this is a lock that makes sure that this function cant run more than once per instance
		$"..".queue_free()
		$"..".get_parent().dropanimalfriend(load(playerlist[0]),GameUtils.FRENVAL,Vector2($"..".position.x,$"..".position.y))
		GameUtils.FRENVAL = 0
	if Input.is_action_just_pressed($"..".C) && $"..".is_jumping == false && p == 2 && candrop == true:
		candrop = false
		$"..".queue_free()
		$"..".get_parent().dropanimalfriend(load(playerlist[1]),GameUtils.FRENVALP2,Vector2($"..".position.x,$"..".position.y))
		GameUtils.FRENVALP2 = 0

func _process(_delta):
	if p == 1:
		p1glob()
	if p == 2:
		p2glob()

func killsuck(boo):
	if p == 1:
		GameUtils.Killsuck = boo
	elif p == 2:
		GameUtils.KillsuckP2 = boo
func killAbility(boo):
	if p == 1:
		GameUtils.KillAbility = boo
	elif p == 2:
		GameUtils.KillAbilityP2 = boo

func mouthvalset(val):
	if p == 1:
		GameUtils.mouthValue = val
	elif p == 2:
		GameUtils.mouthValueP2 = val

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
		$"..".canInhale = false
		GameUtils.KillsuckP2 = true
