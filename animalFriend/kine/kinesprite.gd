extends AnimatedSprite2D

func ani(direction):
#jump ani
	if $"..".is_jumping == true && $"..".flight == false && $"..".inhaling == false && turn == false: 
		if $"..".mouthFull == false && animation != "jump":
			$".".play("jump")

	#determines if walking or idling
	if $"..".falling == false && $"..".overrideX == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".inhaling == false && $"..".crouch == false:
				$".".play("run")
			if $"..".mouthFull == true && $"..".inhaling == false:
				$".".play("fat idle")
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
		$".".play("spit")

	#crouch ani
	if $"..".crouch == true && $".".animation != "crouch":
		$".".play("crouch")

	#inhale ani
	if $"..".inhaling == true && $"..".mouthFull == false && $"..".spit == false:
		$".".play("open")

func swimani(_up,_down):
	if $"../animalfriendcode".bubblestart == true && turn == false:
		play("idle")
	if $"../animalfriendcode".bubblestart == false:
		play("open")
	if not $"..".is_on_floor() && $"../animalfriendcode".bubblestart == true:
		set_speed_scale(0.5)
	else:
		set_speed_scale(1.0)

func abilityani():
	pass

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
	
