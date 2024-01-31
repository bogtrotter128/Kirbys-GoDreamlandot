extends AnimatedSprite2D

#need to add a way to load gooey sprites in

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
	if $"..".is_jumping == true && $"..".flight == false && $"..".inhaling == false && turn == false: 
		if $"..".mouthFull == false && animation != "jump" && animation != "open":
			$".".play("jump")
		elif $"..".mouthFull == true && animation != "fat jump"&& animation != "open":
			$".".play("fat jump")

#directional animation parameters
	if $"..".DIR == -1 && $"..".overrideX == false && $"../AbilitySprites".flip_h == false:
		$".".flip_h = true
		turnframe()
		$"../AbilitySprites".flip_h = true
	if $"..".DIR == 1 && $"..".overrideX == false && $"../AbilitySprites".flip_h == true:
		$".".flip_h = false
		turnframe()
		$"../AbilitySprites".flip_h = false
	
	var direction = Input.get_axis("left", "right")
	#determines if walking or idling
	if $"..".falling == false && $"..".overrideX == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".inhaling == false:
				$".".play("run")
			elif $"..".mouthFull == true && $"..".inhaling == false:
				$".".play("fat run")
			elif $"..".mouthFull == false && $"..".inhaling == true:
				$".".play("open run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false:
					$".".play( "idle")
				elif $"..".mouthFull == true:
					$".".play("fat idle")

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
	if $"..".inhaling == true && not direction:
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
	await get_tree().create_timer(0.15).timeout
	$".".play(saveani)
	$".".frame = saveframe
	turn = false
	
