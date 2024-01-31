extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".DIR = GameUtils.DIRP2

func _input(_event):
	if Input.is_action_just_pressed("recall2") && GameUtils.RECALL == false:
		GameUtils.RECALL = true
		GameUtils.secondplayerrecall = true
		$"..".queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
		GameUtils.KillsuckP2 = true
