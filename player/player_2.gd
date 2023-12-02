extends CharacterBody2D


const SPEED = 80.0

var WINDFORCEX = 0.0
var WINDFORCEY = 0.0
var overrideX = false
var overrideY = false

var hurt = false

#jumps^^^^^^^^^^^^^^^^^^^^^^^
var is_jumping = false
var canJump = true
var jumpMax = GameUtils.JUMPMAX
var jumpCount = 0
const JUMP_VELOCITY_STEP = 1
var jump_power_initial = -150
var jump_power = 0
var jump_time_max = 0.2
var jump_timer = 0.0

###r##u###n###n##i##n##g####
var runCheckR = false
var runCheckL = false
var runcont = false
var run = false

var falling = false
var flight = false

var spit = false
var inhaling = false

var canInhale = true
var mouthFull = false
var mouthFullAir = false

var crouch = false
var crouchOverride = false
var slide = false

var hasAbility = false
var activeAbility = 0
var abilityCooldown = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#this is jsut to tell the game gooey is here
	#should be put it in his summon function
	GameUtils.SECONDPLAYER = true

func _input(event):
	
		#handles spit inpit
	if Input.is_action_just_pressed("a") && mouthFull == true or Input.is_action_just_pressed("a") && mouthFullAir == true:
		$projectileProducer.projectShoot(GameUtils.mouthValueP2)
		$projectileProducer.spitCascade()
	
	if crouch == true && Input.is_action_just_pressed("jump"):
		$projectileProducer.slide()
	
#handles the long jump release time
	if event.is_action_released("jump") && is_jumping:
		jump_timer = jump_time_max
		
#handles multijump
	if Input.is_action_just_pressed("jump") && is_jumping == true && jumpCount < jumpMax && abilityCooldown == false && canInhale == true&& $AnimatedSprite2D.animation != "hurt":
		mouthFullAir = true
		flight = true
		if jumpMax < 999:
			velocity.y = (jump_power_initial * 2) + (20 * jumpCount)
		else:
			velocity.y = jump_power_initial * 2
		jumpCount += 1
		abilityCooldown = true
		$AbilitySprites/abilityCooldown.set_wait_time(0.15)
		$AbilitySprites/abilityCooldown.start()
	
#double tap to run checker
	if Input.is_action_just_released("right") && falling == false or Input.is_action_just_released("left") && falling == false:
		$runCooloff.start()
		if Input.is_action_just_released("right"):
			runCheckR = true
			$doubletap.start()
		elif Input.is_action_just_released("left"):
			runCheckL = true
			$doubletap.start()
	elif runCheckR == true or runcont == true:
		if Input.is_action_pressed("right"):
			run = true
	elif runCheckL == true or runcont == true:
		if Input.is_action_pressed("left"):
			run = true

func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false
func _on_run_cooloff_timeout():
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		run = false

func _process(_delta):
	
	if GameUtils.HEALTHP2 > GameUtils.MAXHPP2:
		GameUtils.HEALTHP2 = GameUtils.MAXHPP2
	
	#rules for when something enters kirby's mouth
#BEFORE swallowing
#after inhaling
	#mouthFull = true basically
	if GameUtils.mouthValueP2 > 1:
		mouthFull = true
		jumpCount = jumpMax
		canInhale = false
		GameUtils.KillsuckP2 = true

#############################################################################
#i n p u t p r o c e s s e s

	if crouch == false or overrideY == false:
		#handles jump input and calls jump function
		if Input.is_action_pressed("jump") && is_jumping == false && canJump == true && inhaling == false:
			jump()
		#while jump is held, jumptimer increases
		if Input.is_action_pressed("jump") && is_jumping == true && jump_timer < jump_time_max:
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)

	if crouchOverride == false && slide == false:
		if Input.is_action_pressed("down"):
			docrouch()
		elif Input.is_action_just_released("down"):
			uncrouch()

	#inhale input and function call
	if Input.is_action_pressed("a") && canInhale == true && abilityCooldown == false:
		$projectileProducer.inhale()
# C button input

	if Input.is_action_just_pressed("c"):
		#handles swallowing
		if mouthFull == true && hasAbility == false:
			swallow()
		#handles animal friend interactions
		
		#+ door interaction

	elif Input.is_action_just_released("a") && GameUtils.KillsuckP2 == false:
		$AbilitySprites/abilityCooldown.set_wait_time(0.43)
		$AbilitySprites/abilityCooldown.start()
		await get_tree().create_timer(0.43).timeout
		$projectileProducer.inhaleStop()
	elif Input.is_action_pressed("a") && mouthFull == true:
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
		if velocity.y < 200:
			velocity.y += gravity * delta
		if flight ==  true:
			velocity.y = velocity.y * 0.86
			velocity.x = velocity.x * 0.75

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

	var direction = Input.get_axis("left", "right")
	#directional parameters
	if direction == -1 && overrideX == false:
		GameUtils.DIRP2 = -1
		$projectileProducer.rotation_degrees = 180
		$projectileProducer.position.x = -8
	elif direction == 1 && overrideX == false:
		GameUtils.DIRP2 = 1
		$projectileProducer.rotation = 0
		$projectileProducer.position.x = 8
	if direction:
		if overrideX == false && slide == false:
			velocity.x = direction * SPEED
	else:
		#this line will be contingecnies where kirby should not stop moving while idle
		if slide == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	#speed parameters run / mouthful / etc
	if run == true && mouthFull == false:
		velocity.x = velocity.x * 1.54
	elif run == true && mouthFull == true:
		velocity.x = velocity.x * 1.2
	elif mouthFull == true && run == false:
		velocity.x = velocity.x * 0.75



#adds wind blowing force
	velocity.x += WINDFORCEX * (delta * 5)
	velocity.y += WINDFORCEY * (delta * 2.5) #add fire contingency later\/\/\/\/
	#if activeAbility != 1: #contingency to make the fireability undisturbed during wind
	#	velocity.y += WINDFORCEY * (delta * 2.5)
#this if statement makes sure kirby doesnt fall through Y wind
	if WINDFORCEY != 0 && velocity.y > 90:
		velocity.y = 50
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
	#abilitycard.update_ability_card(GameUtils.ABILITY)
	GameUtils.mouthValueP2 = 1
	mouthFull = false
	mouthFullAir = false
