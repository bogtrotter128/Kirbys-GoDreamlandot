extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameUtils.SECONDPLAYER == false:
		$"..".queue_free()
	
	$"..".DIR = GameUtils.DIRP2
	if GameUtils.FRENVALP2 > 0:
		await get_tree().create_timer(0.05).timeout
		$"..".get_parent().summonfren($"..",GameUtils.FRENVALP2,$"..".swim)

func _input(_event):
	if Input.is_action_just_pressed("recall2") && GameUtils.RECALL == false:
		GameUtils.RECALL = true
		GameUtils.secondplayerrecall = true
		$"..".queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameUtils.SECONDPLAYER == false:
		$"..".queue_free()
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
	if GameUtils.ABILITYP2 != 7:
		$"..".parasolspawn = false
	#rules for when something enters kirby's mouth
#BEFORE swallowing
#after inhaling
	#mouthFull = true basically
	if GameUtils.mouthValueP2 > 1:
		$"..".mouthFull = true
		$"..".jumpCount = $"..".jumpMax
		$"..".canInhale = false
