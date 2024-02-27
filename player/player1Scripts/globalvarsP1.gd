extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".DIR = GameUtils.DIR
	if GameUtils.FRENVAL > 0:
		await get_tree().create_timer(0.05).timeout
		$"..".get_parent().summonfren($"..",GameUtils.FRENVAL,$"..".swim)

func _input(_event):
	if Input.is_action_just_pressed("recall1") && GameUtils.RECALL == false && GameUtils.SECONDPLAYER == true:
		GameUtils.RECALL = true
		GameUtils.firstplayerrecall = true
		$"..".queue_free()
	if Input.is_action_just_pressed("recall1") && GameUtils.SECONDPLAYER == false:
		$"..".get_parent().gooeyspawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#gets kirbys global position
	GameUtils.posX = $"..".global_position.x
	GameUtils.posY = $"..".global_position.y
	
	#global variable tracker
	GameUtils.DIR = $"..".DIR
	
	if GameUtils.MAXHP < 9999:
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
