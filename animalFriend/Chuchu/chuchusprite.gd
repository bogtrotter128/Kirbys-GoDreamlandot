extends AnimatedSprite2D

var climbani = false

func ani(direction):
#jump ani
	if $"..".is_jumping == true && $"../animalfriendcode".jumpCount < 1 && $"..".inhaling == false && turn == false && climbani == false: 
		if $"..".mouthFull == false && animation != "jump":
			$".".play("jump")
		elif $"..".mouthFull == true && animation != "fat jump":
			$".".play("fat jump")
	if Input.is_action_just_pressed($"..".JUMP) && $"../animalfriendcode".jumpCount >= 1:
		play("flap")
		await animation_finished
		$".".play("jump")

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
	if $"..".inhaling == true && $"..".mouthFull == false:
		$".".play("open")

func swimani(_up,_down):
	if $"../animalfriendcode".bubblestart == true && turn == false:
		play("swim")
	if animation != "swim" && animation != "open":
		set_speed_scale(0.5)
	else:
		set_speed_scale(1.0)

func abilityani():
	pass

var saveframe
var saveani
var turn = false
func turnframe():
	saveframe = frame
	saveani = animation
	stop()
	turn = true
	if $"..".mouthFull == false:
		play("turn")
	if $"..".mouthFull == true:
		play("fat turn")
	if $"../animalfriendcode".jumpCount >= 1:
		play("flapturn")
	if climbani == true:
		play("climbturn")
	if $"..".swim == true && not $"..".is_on_floor():
		play("flapturn")
	await get_tree().create_timer(0.15).timeout
	play(saveani)
	frame = saveframe
	turn = false
	
