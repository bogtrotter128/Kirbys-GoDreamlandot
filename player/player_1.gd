extends CharacterBody2D

var SPEED = 80.0
var frenval

var overrideX = false
var overrideY = false

var hurt = false
var iframes = false

#jumps^^^^^^^^^^^^^^^^^^^^^^^
var is_jumping = false
var canJump = true
var jumpMax = GameUtils.JUMPMAX
var jumpCount = 0
const JUMP_VELOCITY_STEP = 0.01
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
##################################################################

var UP
var DOWN
var LEFT
var RIGHT

var A
var JUMP
var C
var SELECT
var DIR
func _ready():
	if is_in_group("player1"):
		UP = "up"
		DOWN = "down"
		LEFT = "left"
		RIGHT = "right"
		A = "a"
		JUMP = "jump" 
		C = "c"
		SELECT = "select"
	if is_in_group("player2"):
		UP = "P2up"
		DOWN = "P2down"
		LEFT = "P2left"
		RIGHT = "P2right"
		A = "P2a"
		JUMP = "P2jump" 
		C = "P2c"
		SELECT = "P2select"

func _input(event):
#slide input
	if crouch == true && Input.is_action_just_pressed(JUMP):
		$projectileProducer.slide()
	
#handles the long jump release time
	if event.is_action_released(JUMP) && is_jumping:
		jump_timer = jump_time_max
		
#handles multijump
	if Input.is_action_just_pressed(JUMP) && is_jumping == true && jumpCount < jumpMax && jumpCooldown == false && canInhale == true && hurt == false:
		mouthFullAir = true
		flight = true
		if jumpCount <= 6:
			velocity.y = (jump_power_initial) + (20 * jumpCount)
		else:
			velocity.y = -20
		jumpCount += 1
		jumpCooldown = true
		$jumpcooldown.set_wait_time(0.15)
		$jumpcooldown.start()
	
	if Input.is_action_just_pressed(SELECT) && hasAbility == true && crouch == false && canInhale == true:
		$projectileProducer.projectShoot($projectileProducer.dropabilitystar)

#double tap to run checker
	if Input.is_action_just_released(RIGHT) && falling == false or Input.is_action_just_released(LEFT) && falling == false:
		$runCooloff.start()
		if Input.is_action_just_released(RIGHT):
			runCheckR = true
			$doubletap.start()
		elif Input.is_action_just_released(LEFT):
			runCheckL = true
			$doubletap.start()
	elif runCheckR == true or runcont == true:
		if Input.is_action_pressed(RIGHT):
			run = true
	elif runCheckL == true or runcont == true:
		if Input.is_action_pressed(LEFT):
			run = true

func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false
func _on_run_cooloff_timeout():
	if not Input.is_action_pressed(RIGHT) and not Input.is_action_pressed(LEFT):
		run = false
		cancheckrun = true

func _process(_delta):
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

	if crouch == false && overrideY == false:
		#handles jump input and calls jump function
		if Input.is_action_pressed(JUMP) && is_jumping == false && canJump == true && inhaling == false:
			jump()
		#while jump is held, jumptimer increases
		if Input.is_action_pressed(JUMP) && is_jumping == true && jump_timer < jump_time_max:
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)

	if crouchOverride == false && slide == false:
		if Input.is_action_pressed(DOWN):
			docrouch()
		elif Input.is_action_just_released(DOWN):
			uncrouch()

	#inhale input and function call
	##ability input call
	if Input.is_action_pressed(A) && abilityCooldown == false && crouch == false:
		if canInhale == true && hasAbility == false:
			$projectileProducer.inhale()
		elif hasAbility == true && is_in_group("player1"):
			$projectileProducer.ability(GameUtils.ABILITY)
		elif hasAbility == true && is_in_group("player2"):
			$projectileProducer.ability(GameUtils.ABILITYP2)
	if Input.is_action_just_released(A) && abilitycanstop == true:
		$projectileProducer.abilityStop()

# C button input
	if Input.is_action_just_pressed(C):
		#handles swallowing
		if mouthFull == true && hasAbility == false:
			swallow()
		#handles animal friend interactions
		

#stop inhaling
	elif Input.is_action_just_released(A) && hasAbility == false:
		$AbilitySprites/abilityCooldown.set_wait_time(0.43)
		$AbilitySprites/abilityCooldown.start()
		await get_tree().create_timer(0.43).timeout
		$projectileProducer.inhaleStop()
	elif Input.is_action_pressed(A) && mouthFull == true:
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
			mouthFullAir = false
			$projectileProducer.projectShoot($projectileProducer.airpuff)
			$projectileProducer.spitCascade()
		falling = false
		flight = false
		canJump = true
		jumpCount = 0
		jump_timer = 0.0
		is_jumping = false

	var direction = Input.get_axis(LEFT, RIGHT)
	#directional parameters
	if direction == -1 && overrideX == false:
		DIR = -1
	elif direction == 1 && overrideX == false:
		DIR = 1
	if DIR == 1 && activeAbility != 4:
		$projectileProducer.rotation = 0
		$projectileProducer.position.x = 8
	elif DIR == -1 && activeAbility != 4:
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
	jumpCount = 0
	$normalhitbox.call_deferred("set", "disabled", false)

func swallow():
	canInhale = true
	if is_in_group("player1"):
		GameUtils.ABILITY = GameUtils.HELDABILITY
		GameUtils.mouthValue = 1
		Hud.updateability()
	if is_in_group("player2"):
		GameUtils.ABILITYP2 = GameUtils.HELDABILITYP2
		GameUtils.mouthValueP2 = 1
		Hud.updateability2()
	mouthFull = false
	mouthFullAir = false

func heal(v):
	if is_in_group("player1"):
		GameUtils.HEALTH += v
		Hud.updatehp()
	if is_in_group("player2"):
		GameUtils.HEALTHP2 += v
		Hud.updatehp2()

