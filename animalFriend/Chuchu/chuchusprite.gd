extends AnimatedSprite2D

#need to add a way to load gooey sprites in
var climbani = false
func _ready():
	if $"..".is_in_group("player1"):
		pass #kirby sprites
	if $"..".is_in_group("player2"):
		pass #gooey sprites

func _process(_delta):
	if $"..".activeAbility != 0:
		$".".visible=false
	else:
		$".".visible=true
#jump ani
	if $"..".is_jumping == true && $"../animalfriendcode".jumpCount < 1 && $"..".inhaling == false && turn == false && climbani == false: 
		if $"..".mouthFull == false && animation != "jump":
			$".".play("jump")
		elif $"..".mouthFull == true && animation != "fat jump":
			$".".play("fat jump")
	if Input.is_action_just_pressed($"..".JUMP) && $"../animalfriendcode".jumpCount >= 1:
		play("flap")

#directional animation parameters
	if $"..".DIR == -1 && $"..".inhaling == false && $"../AbilitySprites".flip_h == false:
		$".".flip_h = true
		turnframe()
		$"../AbilitySprites".flip_h = true
	if $"..".DIR == 1 && $"..".inhaling == false && $"../AbilitySprites".flip_h == true:
		$".".flip_h = false
		turnframe()
		$"../AbilitySprites".flip_h = false
	
	var direction = Input.get_axis("left", "right")
	#determines if walking or idling
	if $"..".inhaling == false && $"..".overrideX == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".falling == false:
				$".".play("run")
			elif $"..".mouthFull == true && $"..".falling == false:
				$".".play("fat run")
			if climbani == true:
				play("climbrun")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false && climbani == false && $"..".falling == false:
					$".".play( "idle")
				elif $"..".mouthFull == true && $"..".falling == false:
					$".".play("fat idle")
				if climbani == true:
					play("climbidle")

	#run ani
	if $"..".run == true && $"..".crouch == false && $"..".falling == false:
		$".".set_speed_scale(1.5)
	elif $"..".run == false:
		$".".set_speed_scale(1.0)
	
	#spit ani
	if $"..".spit == true:
		$".".play("open")

	#crouch ani
	if $"..".crouch == true && $".".animation != "crouch":
		$".".play("crouch")

	#inhale ani
	if $"..".inhaling == true:
		$".".play("open")

	if $"..".hurt == true && $"..".mouthFull == false:
		$".".play("hurt")
	elif $"..".hurt == true && $"..".mouthFull == true:
		$".".play("fat hurt")
var saveframe
var saveani
var turn = false
func turnframe():
	saveframe = $".".frame
	saveani = $".".animation
	$".".stop()
	turn = true
	if $"..".mouthFull == false:
		$".".play("turn")
	if $"..".mouthFull == true:
		$".".play("fat turn")
	if $"../animalfriendcode".jumpCount >= 1:
		play("flapturn")
	if climbani == true:
		play("climbturn")
	await get_tree().create_timer(0.15).timeout
	$".".play(saveani)
	$".".frame = saveframe
	turn = false
	
