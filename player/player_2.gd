extends CharacterBody2D


var SPEED = 80.0

var WINDFORCEX = 0.0
var WINDFORCEY = 0.0
var overrideX = false
var overrideY = false

var hurt = false
var iframes = false

#jumps^^^^^^^^^^^^^^^^^^^^^^^
var is_jumping = false
var canJump = true
var jumpMax = GameUtils.JUMPMAX
var jumpCount = 0
const JUMP_VELOCITY_STEP = 0.5
var jump_power_initial = -150
var jump_power = 0
var jump_time_max = 0.2
var jump_timer = 0.0
var jumpCooldown = false

###r##u###n###n##i##n##g####
var runCheckR = false
var runCheckL = false
var runcont = false
var run = false
var cancheckrun = false

var falling = false
var flight = false
var squish = false

var spit = false
var inhaling = false

var canInhale = true
var mouthFull = false
var mouthFullAir = false

var crouch = false
var crouchOverride = false
var slide = false

var abilitycanstop = true
var hasAbility = false
var activeAbility = 0
var abilityCooldown = false

func _ready():
	#this is jsut to tell the game gooey is here
	#should be put it in his summon function
	GameUtils.SECONDPLAYER = true
	$damDect/damshape.call_deferred("set", "disabled", false)
	$smallhitbox.call_deferred("set", "disabled", false)
	$normalhitbox.call_deferred("set", "disabled", false)
	#Hud.updatehp2()

func _input(event):
		#handles spit inpit
	if Input.is_action_just_pressed("P2a") && mouthFull == true or Input.is_action_just_pressed("P2a") && mouthFullAir == true:
		$projectileProducer.projectShoot(GameUtils.mouthValueP2)
		$projectileProducer.spitCascade()
	
	if crouch == true && Input.is_action_just_pressed("P2jump"):
		$projectileProducer.slide()
	
#handles the long jump release time
	if event.is_action_released("P2jump") && is_jumping:
		jump_timer = jump_time_max
		
#handles multijump
	if Input.is_action_just_pressed("P2jump") && is_jumping == true && jumpCount < jumpMax && jumpCooldown == false && canInhale == true&& $AnimatedSprite2D.animation != "hurt":
		mouthFullAir = true
		flight = true
		velocity.y = (jump_power_initial) + (20 * jumpCount)
		jumpCount += 1
		jumpCooldown = true
		$jumpcooldown.set_wait_time(0.15)
		$jumpcooldown.start()

#double tap to run checker
	if Input.is_action_just_released("P2right") && falling == false or Input.is_action_just_released("P2left") && falling == false:
		$runCooloff.start()
		if Input.is_action_just_released("P2right"):
			runCheckR = true
			$doubletap.start()
		elif Input.is_action_just_released("P2left"):
			runCheckL = true
			$doubletap.start()
	elif runCheckR == true or runcont == true:
		if Input.is_action_pressed("P2right"):
			run = true
	elif runCheckL == true or runcont == true:
		if Input.is_action_pressed("P2left"):
			run = true

func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false
func _on_run_cooloff_timeout():
	if not Input.is_action_pressed("P2right") and not Input.is_action_pressed("P2left"):
		run = false
		cancheckrun = true

func _process(_delta):
	GameUtils.posXP2 = global_position.x
	GameUtils.posYP2 = global_position.y
	
	if GameUtils.HEALTHP2 > GameUtils.MAXHPP2:
		GameUtils.HEALTHP2 = 8
	if GameUtils.HEALTHP2 <= 0:
		death()
	
	if GameUtils.ABILITYP2 > 0:
		hasAbility = true
	else:
		hasAbility = false
	#rules for when something enters kirby's mouth
#BEFORE swallowing
#after inhaling
	#mouthFull = true basically
	if GameUtils.mouthValueP2 > 1:
		mouthFull = true
		jumpCount = jumpMax
		canInhale = false
		GameUtils.KillsuckP2 = true

#this stops kirby from moving while an ability is active and on the floor
#excludes the fire ability ( > 1)
#this is mostly for the parasol ability so kirb wont slide while moving
	if activeAbility > 0 && is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 5)
		overrideX = true
		velocity.y = 0
		canJump = false
#############################################################################
#i n p u t p r o c e s s e s

	if crouch == false or overrideY == false:
		#handles jump input and calls jump function
		if Input.is_action_pressed("P2jump") && is_jumping == false && canJump == true && inhaling == false:
			jump()
		#while jump is held, jumptimer increases
		if Input.is_action_pressed("P2jump") && is_jumping == true && jump_timer < jump_time_max:
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)

	if crouchOverride == false && slide == false:
		if Input.is_action_pressed("P2down"):
			docrouch()
		elif Input.is_action_just_released("P2down"):
			uncrouch()

	#inhale input and function call
	##ability input call
	if Input.is_action_pressed("P2a") && abilityCooldown == false && crouch == false:
		if canInhale == true && hasAbility == false:
			$projectileProducer.inhale()
		elif hasAbility == true:
			$projectileProducer.ability(GameUtils.ABILITYP2)
	if Input.is_action_just_released("P2a") && abilitycanstop == true:
		GameUtils.KillAbilityP2 = true
		GameUtils.KillAbilityP2 = false
		$projectileProducer.abilityStop()

# C button input
	if Input.is_action_just_pressed("P2c"):
		#handles swallowing
		if mouthFull == true && hasAbility == false:
			swallow()
		#handles animal friend interactions
		
		#+ door interaction

#stop inhaling
	elif Input.is_action_just_released("P2a") && hasAbility == false:
		$AbilitySprites/abilityCooldown.set_wait_time(0.43)
		$AbilitySprites/abilityCooldown.start()
		await get_tree().create_timer(0.43).timeout
		$projectileProducer.inhaleStop()
	elif Input.is_action_pressed("a") && mouthFull == true:
			$projectileProducer.inhaleStop()
	elif inhaling == true && mouthFull == true:
		$projectileProducer.inhaleStop()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() && overrideY == false:
		falling = true
		#no mid-air jump
		canJump = false
		#but can still multijump\/
		if slide == false:
			is_jumping = true
		jump_timer += delta
		if flight == false:
			velocity.y = move_toward(velocity.y, 200, 7)
		elif flight == true:
			velocity.y = move_toward(velocity.y, 40, 7)

#landing parameters
	if is_on_floor() && falling == true && crouch == false && slide == false:
		if mouthFullAir == true:
			$projectileProducer.projectShoot(GameUtils.mouthValueP2)
			#spitoutairpuff func
		falling = false
		flight = false
		mouthFullAir = false
		canJump = true
		jumpCount = 0
		jump_timer = 0.0
		is_jumping = false

	var direction = Input.get_axis("P2left", "P2right")
	#directional parameters
	if direction == -1 && overrideX == false:
		GameUtils.DIRP2 = -1
	elif direction == 1 && overrideX == false:
		GameUtils.DIRP2 = 1
	if GameUtils.DIRP2 == 1 && activeAbility != 4:
		$projectileProducer.rotation = 0
		$projectileProducer.position.x = 8
	elif GameUtils.DIRP2 == -1 && activeAbility != 4:
		$projectileProducer.rotation_degrees = 180
		$projectileProducer.position.x = -8
	if direction:
		if overrideX == false && slide == false && inhaling == false:
			velocity.x = move_toward(velocity.x, SPEED * direction, 4)
			cancheckrun = true
	else:
		#this line will be contingecnies where kirby should not stop moving while idle
		if slide == false && activeAbility == 0:
			velocity.x = move_toward(velocity.x, 0, 7)
			if cancheckrun == true:
				cancheckrun = false
				$runCooloff.start()

	#speed parameters run / mouthful / etc
	if overrideX == false: #this stops the whole override x form breaking
		if run == true && mouthFull == false:
			SPEED = 123
		elif run == true && mouthFull == true:
			SPEED = 96
		elif mouthFull == true && run == false:
			SPEED = 60
		if flight == true:
			SPEED = 70
	if run == false:
		SPEED = 80

#squishes/boucnes when hits wall. 
#max angle was set to 50' so to not collide with slopes
	if is_on_wall() && falling == false && run == true:
		run = false
		squish = true

#adds wind blowing force
	if WINDFORCEX > 0 && velocity.x < WINDFORCEX or WINDFORCEX < 0 && velocity.x > WINDFORCEX:
		velocity.x = move_toward(velocity.x, velocity.x + WINDFORCEX, 5)
#		velocity.x += WINDFORCEX * (delta * 1.4)
	if WINDFORCEY != 0 && activeAbility != 1:  #contingency to make the fireability undisturbed during wind
		velocity.y = move_toward(velocity.y, WINDFORCEY, 16)
#		velocity.y += WINDFORCEY * (delta * 2.5)
	move_and_slide()

func jump():
	if is_jumping == false:
		jump_timer = 0.0
		is_jumping = true
		apply_jump_force(jump_power_initial)
		jump_power = jump_power_initial

func apply_jump_force(power):
	velocity.y = power

func docrouch():
	if mouthFull == true:
		swallow()
	if is_on_floor():
		velocity.x = 0
		crouch = true
		overrideX = true
		canJump = false
		jumpCount = GameUtils.JUMPMAX
		canInhale = false
		$normalhitbox.call_deferred("set", "disabled", true)
	
func uncrouch():
	velocity.x = 0
	crouch = false
	overrideX = false
	canInhale = true
	canJump = true
	$normalhitbox.call_deferred("set", "disabled", false)

func swallow():
	canInhale = true
	GameUtils.ABILITYP2 = GameUtils.HELDABILITYP2
	Hud.updateability2()
	GameUtils.mouthValueP2 = 1
	mouthFull = false
	mouthFullAir = false

func heal(v):
	GameUtils.HEALTHP2 += v
	Hud.updatehp2()

func death():
	GameUtils.SECONDPLAYER = false
	GameUtils.HEALTHP2 = 1
	$damDect/damshape.call_deferred("set", "disabled", true)
	$smallhitbox.call_deferred("set", "disabled", true)
	$normalhitbox.call_deferred("set", "disabled", true)
#	activeAbility = 11
	GameUtils.posXP2 = 0
	GameUtils.posYP2 = 0
	self.queue_free()
