extends AnimatedSprite2D
#if any animations starts playing but the frames dont progress, it means:
#another aniamtion is fighting to play at the same time

var parasolsprite = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameUtils.ABILITY == 7:
		parasolsprite = true
	else:
		parasolsprite = false
	
	if $"..".activeAbility != 0:
		$".".visible=false
	else:
		$".".visible=true
	
#jump ani
	if $"..".is_jumping == true && $"..".flight == false && $"..".inhaling == false: 
		if parasolsprite == false:
			if $"..".mouthFull == false:
				$".".play("jump")
			elif $"..".mouthFull == true:
				$".".play("fat jump")
		elif parasolsprite == true && $"..".mouthFull == false:
			$".".play("parajump")

#flight ani
	if $"..".flight == true:
		if $".".animation != "flap" && $".".animation != "paraFlap" && turn == false:
			if parasolsprite == false:
				$".".play("flight")
			else:
				$".".play("paraflight")
		if Input.is_action_just_pressed("jump"):
			if parasolsprite == false:
				$".".play("flap")
			elif parasolsprite == true:
				$".".play("paraFlap")
			await $".".animation_finished
			if parasolsprite == false:
				$".".play("flight")
			else:
				$".".play("paraflight")
	
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
	if $"..".falling == false && $"..".inhaling == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".overrideX == false:
				if parasolsprite == false && $"..".run == false:
					$".".play("walk")
				elif parasolsprite == true:
					$".".play("pararun")
			elif $"..".mouthFull == true && $"..".overrideX == false:
				$".".play("fat run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false:
					if parasolsprite == false:
						$".".play("idle")
					else:
						$".".play("paraidle")
				elif $"..".mouthFull == true:
					$".".play("fat idle")

	#run ani
	if $"..".run == true && $"..".squish== false && $"..".crouch == false && $"..".falling == false:
		$".".set_speed_scale(1.5)
		if $"..".mouthFull == false && parasolsprite == false && turn == false:
			$".".play("run")
	elif $"..".run == false:
		$".".set_speed_scale(1.0)
		
	#spit ani
	if $"..".spit == true:
		if parasolsprite == false:
			$".".play("open")
		else:
			$".".play("paraopen")

	#crouch ani
	if $"..".crouch == true && $".".animation != "crouch":
		if parasolsprite == false:
			$".".play("crouch")
		else:
			$".".play("paracrouch")

	#slide ani
	if $"..".slide == true:
		$".".play("slide")

	#inhale ani
	if $"..".inhaling == true:
		$".".play("open")
	elif $"..".inhaling == false:
		$".".position.x = 0
 
	if $"..".squish == true:
		$".".play("squish")
		await get_tree().create_timer(0.1).timeout
		$"..".squish = false
	
	if $"..".hurt == true:
		$".".play("hurt")

var turn = false
func turnframe():
	$".".stop()
	turn = true
	if $"..".mouthFull == false:
		if parasolsprite == false:
			$".".play("turn")
		if parasolsprite == true:
			$".".play("para turn")
	if $"..".mouthFull == true:
		$".".play("fat turn")
	if $"..".flight == true:
		if parasolsprite == false:
			$".".play("flight turn")
		if parasolsprite == true:
			$".".play("para flight turn")
	await get_tree().create_timer(0.13).timeout
	turn = false
