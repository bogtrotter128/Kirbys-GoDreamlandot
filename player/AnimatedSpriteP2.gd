extends AnimatedSprite2D
#if any animations starts playing but the frames dont progress, it means:
#another aniamtion is fighting to play at the same time

var parasolsprite = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameUtils.ABILITYP2 == 7:
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
		else:
			if $"..".mouthFull == false:
					$".".play("parajump")
#flight ani
	if $"..".flight == true:
		if $".".animation != "flap":
			if parasolsprite == false:
				$".".play("flight")
			else:
				$".".play("paraflight")
		if Input.is_action_just_pressed("jump"):
			$".".play("flap")
			await $".".animation_finished
			if parasolsprite == false:
				$".".play("flight")
			else:
				$".".play("paraflight")
	
#directional animation parameters
	if GameUtils.DIRP2 == -1:
		$".".flip_h = true
		$"../AbilitySprites".flip_h = true
	if GameUtils.DIRP2 == 1:
		$".".flip_h = false
		$"../AbilitySprites".flip_h = false
	
	var direction = Input.get_axis("left", "right")
	#determines if walking or idling
	if $"..".falling == false && $"..".inhaling == false:
		if direction:
			if $"..".mouthFull == false && $"..".overrideX == false:
				if parasolsprite == false:
					$".".play("walk")
				else:
					$".".play("pararun")
			elif $"..".mouthFull == true && $"..".overrideX == false:
				$".".play("fat run")
		else:
			if $"..".crouch == false && $"..".inhaling == false:
				if $"..".mouthFull == false:
					if parasolsprite == false:
						$".".play("idle")
					else:
						$".".play("paraidle")
				elif $"..".mouthFull == true:
					$".".play("fat idle")

	if $"..".run == true && $"..".squish== false:
		$".".set_speed_scale(1.5)
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
		$".".play("tongue")
		$".".position.x = +(GameUtils.DIRP2 * 9)
	elif $"..".inhaling == false:
		$".".position.x = 0
 
	if $"..".squish == true:
		$".".play("squish")
		await get_tree().create_timer(0.1).timeout
		$"..".squish = false
	
	if $"..".hurt == true:
		$".".play("hurt")
