extends AnimatedSprite2D
#if any animations starts playing but the frames dont progress, it means:
#another aniamtion is fighting to play at the same time

var parasolsprite = false
var up = false
var down = false
func _input(_event):
	#rotation rules for swimming animations
	if $"..".swim == true && $"..".overrideX == false && $"..".hasAbility == false && not $"..".is_on_floor():
		if Input.is_action_pressed($"..".UP) or Input.is_action_pressed($"..".JUMP):
			up = true
			down = false
		if Input.is_action_pressed($"..".DOWN):
			down = true
			up = false
		if Input.is_action_pressed($"..".LEFT) or Input.is_action_pressed($"..".RIGHT):
			up = false
			down = false

func _process(_delta):
	if $"..".activeAbility != 0:
		visible=false
	else:
		visible=true
#directional animation parameters
	if $"..".DIR == -1 && $"..".inhaling == false && $"..".overrideX == false && flip_h == false:
		flip_h = true
		turnframe()
		$"../AbilitySprites".flip_h = true
	if $"..".DIR == 1 && $"..".inhaling == false && $"..".overrideX == false && flip_h == true:
		flip_h = false
		turnframe()
		$"../AbilitySprites".flip_h = false
	var direction = Input.get_axis($"..".LEFT, $"..".RIGHT)
	if $"..".swim == false or $"..".is_on_floor() && $"../projectileProducer".bubblestart == true or $"..".mouthFull == true:
		down = false
		groundani(direction)
	if $"..".swim == true && $"..".mouthFull == false && not $"..".is_on_floor():
		swimani()
	
	if $"..".hurt == true &&  $"..".mouthFull == false:
		play("hurt")
	if $"..".hurt == true &&  $"..".mouthFull == true:
		play("fat hurt")
	if $"../projectileProducer".bubblestart == false:
		if up == true:
			play("swim blow up")
		if down == true:
			play("swim blow down")
		if up == false && down == false:
			play("swim blow")

func groundani(direction):
	if $"..".parasolspawn == true:
		parasolsprite = true
	if $"..".parasolspawn == false:
		parasolsprite = false
	
#jump ani
	if $"..".is_jumping == true && $"..".flight == false && $"..".inhaling == false: 
		if parasolsprite == false:
			if $"..".mouthFull == false:
				play("jump")
			elif $"..".mouthFull == true:
				play("fat jump")
		elif parasolsprite == true && $"..".mouthFull == false && $"..".parafloat == false:
			play("parajump")

#flight ani
	if $"..".flight == true:
		if animation != "flap" && animation != "paraFlap" && turn == false:
			if parasolsprite == false:
				play("flight")
			else:
				play("paraflight")
		if Input.is_action_just_pressed($"..".JUMP):
			if parasolsprite == false:
				play("flap")
			elif parasolsprite == true:
				play("paraFlap")
			await animation_finished
			if parasolsprite == false:
				play("flight")
			else:
				play("paraflight")
	#parasolfloat
	if $"..".parafloat == true && $"..".is_jumping == true:
		play("parafloat")
		
	#determines if walking or idling
	if $"..".falling == false && $"..".inhaling == false && turn == false:
		if direction:
			if $"..".mouthFull == false && $"..".overrideX == false:
				if parasolsprite == false && $"..".run == false:
					play("walk")
				elif parasolsprite == true:
					play("pararun")
			elif $"..".mouthFull == true && $"..".overrideX == false:
				play("fat run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false && $"..".spit == false:
				if $"..".mouthFull == false:
					if parasolsprite == false:
						play("idle")
					else:
						play("paraidle")
				elif $"..".mouthFull == true:
					play("fat idle")

	#run ani
	if $"..".run == true && $"..".squish == false && $"..".crouch == false && $"..".falling == false:
		set_speed_scale(1.5)
		if $"..".mouthFull == false && parasolsprite == false && turn == false:
			if $"..".iceabilityready == true:
				play("ice skate")
			else:
				play("run")
	elif $"..".run == false:
		set_speed_scale(1.0)
		
	#spit ani
	if $"..".spit == true:
		if parasolsprite == false:
			play("spit")
		else:
			play("paraopen")

	#crouch ani
	if $"..".crouch == true && animation != "crouch":
		if parasolsprite == false && $"..".iceabilityready == false:
			play("crouch")
		if parasolsprite == true:
			play("paracrouch")
		if $"..".iceabilityready == true && animation != "ice crouch":
			play("ice crouch")

	#slide ani
	if $"..".slide == true:
		play("slide")

	#inhale ani
	if $"..".inhaling == true && $"..".spit == false:
		play("open")
	#swuish ani
	if $"..".squish == true:
		play("squish")
		await get_tree().create_timer(0.1).timeout
		$"..".squish = false

func swimani():
	if $"../projectileProducer".bubblestart == true && turn == false:
		if up == false && down == false:
			play("swim")
		if up == true:
			play("swim up")
		if down == true:
			play("swim down")
	if $"..".is_on_floor() && $"../projectileProducer".bubblestart == true:
		set_speed_scale(0.5)
	else:
		set_speed_scale(1.0)
	
var turn = false
func turnframe():
	stop()
	turn = true
	if $"..".mouthFull == false && $"..".swim == false or $"..".mouthFull == false && $"..".is_on_floor():
		if parasolsprite == false:
			play("turn")
		if parasolsprite == true:
			play("para turn")
	if $"..".mouthFull == true:
		play("fat turn")
	if $"..".flight == true:
		if parasolsprite == false:
			play("flight turn")
		if parasolsprite == true:
			play("para flight turn")
	if $"..".swim == true && not $"..".is_on_floor() && $"..".mouthFull == false:
		play("swim turn")
	await get_tree().create_timer(0.13).timeout
	turn = false
