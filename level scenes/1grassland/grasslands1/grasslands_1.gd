extends Node2D


func _ready():
	$playerloadinscene/Camera2D.set_limit(SIDE_LEFT, 0)
	$playerloadinscene/Camera2D.set_limit(SIDE_RIGHT, 3696)
	$playerloadinscene/Camera2D.set_limit(SIDE_TOP, -111)
	$playerloadinscene/Player1.position.x += 48
	$playerloadinscene/Player2.position.x += 32
	

var uiInputs = ["1","2","3","4","5","6","7","8"]
var hashTable = {
	"1":1,
	"2":2,
	"3":3,
	"4":4,
	"5":5,
	"6":6,
	"7":7,
	"8":8,
}

func _input(event):
	if event.as_text() in uiInputs:
		GameUtils.ABILITY = hashTable[event.as_text()]
		GameUtils.ABILITYP2 = hashTable[event.as_text()]
		Hud.updateability()
		Hud.updateability2()
	
	if Input.is_action_just_pressed("debug9"):
		await get_tree().create_timer(0.2).timeout
		GameUtils.ABILITY = 0
		GameUtils.ABILITYP2 = 0
		Hud.updateability()
		Hud.updateability2()
		GameUtils.STARS += 1
		print("FULL")
		GameUtils.HEALTH += 1
		GameUtils.HEALTHP2 +=1
		
		GameUtils.mouthValue = 2
		GameUtils.mouthValueP2 = 2
		await get_tree().create_timer(0.2).timeout
		
	if Input.is_action_just_pressed("debug0"):
		GameUtils.HEALTH = 1
		Hud.updatehp()
		Hud.updatehp2()
		GameUtils.STARS = 1
