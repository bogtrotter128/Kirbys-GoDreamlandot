extends AnimatedSprite2D

func ani(direction):
#jump ani
	if $"..".is_jumping == true && $"../animalfriendcode".jumpCount <1  && $"..".inhaling == false && turn == false: 
		if $"..".mouthFull == false && animation != "jump":
			$".".play("jump")
		elif $"..".mouthFull == true && animation != "fat jump":
			$".".play("fat jump")

#flight ani
	if $"../animalfriendcode".jumpCount >1 && turn == false && $"..".inhaling == false:
		if $"..".mouthFull == false:
			$".".play("flight")
		if $"..".mouthFull == true:
			$".".play("fat flight")
	#determines if walking or idling
	if $"..".falling == false && $"..".inhaling == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".overrideX == false && $"..".run == false:
				$".".play("walk")
			elif $"..".mouthFull == true && $"..".overrideX == false:
				$".".play("fat run")
			if $"..".mouthFull == false && turn == false && $"..".run == true:
				$".".play("run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false:
					$".".play("idle")
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
	if $"..".inhaling == true && $"..".mouthFull == false:
		$".".play("open")

func swimani(up,down):
	if $"../animalfriendcode".bubblestart == true && turn == false:
		play("swim")
	if $"../animalfriendcode".bubblestart == false:
		if up == true:
			play("swim blow up")
		if down == true:
			play("swim blow down")
		if up == false && down == false:
			play("swim blow")
	if not $"..".is_on_floor() && $"../animalfriendcode".bubblestart == true:
		set_speed_scale(0.5)
	else:
		set_speed_scale(1.0)

func abilityani():
	pass

var turn = false
func turnframe():
	$".".stop()
	turn = true
	if $"..".mouthFull == false && $"..".run == true && $"..".is_jumping == false:
		$".".play("run turn")
	if $"..".mouthFull == false && $"..".run == false:
		$".".play("turn")
	if $"..".mouthFull == true && $"../animalfriendcode".jumpCount <1:
		$".".play("fat turn")
	if $"../animalfriendcode".jumpCount >1:
		$".".play("flight turn")
	if $"..".mouthFull == true && $"../animalfriendcode".jumpCount >1:
		$".".play("fat flight turn")
	await get_tree().create_timer(0.13).timeout
	turn = false
