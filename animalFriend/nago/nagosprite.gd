extends AnimatedSprite2D
var dbjump = false

func ani(direction):
#jump ani
	if $"..".is_jumping == true && $"..".inhaling == false && turn == false && dbjump == false: 
		if $"..".mouthFull == false && animation != "jump":
			$".".play("jump")
		elif $"..".mouthFull == true && animation != "fat jump":
			$".".play("fat jump")
	if Input.is_action_just_pressed($"..".JUMP) && dbjump == true:
		play("jumpdouble")
		await animation_finished
		dbjump = false

	#determines if walking or idling
	if $"..".inhaling == false && $"..".overrideX == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".falling == false:
				$".".play("run")
			elif $"..".mouthFull == true && $"..".falling == false:
				$".".play("fat run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false && $"..".falling == false:
					$".".play("idle")
				elif $"..".mouthFull == true && $"..".falling == false:
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
