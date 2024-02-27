extends CharacterBody2D

var frenval

var SPEED = 80.0
var SPEEDELTA = 4

var overrideX = false
var overrideY = false

var hurt = false
var iframes = false
var normaldamageguard = false

#jumps^^^^^^^^^^^^^^^^^^^^^^^
var is_jumping = false
var canJump = true
const JUMP_VELOCITY_STEP = 0.09
var jump_power_initial = -150
var jump_power = 0
var jump_time_max = 0.3
var jump_timer = 0.0
var jumpCooldown = false

###r##u###n###n##i##n##g####
var runCheckR = false
var runCheckL = false
var runcont = false
var run = false
var cancheckrun = false

var swim = true
var falling = false
var flight = false
var squish = false

var spit = false
var inhaling = false

var canInhale = true
var mouthFull = false

var crouch = false
var crouchOverride = false

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
var DIRV
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
	#handles spit inpit
	if Input.is_action_just_pressed(A) && mouthFull == true:
		if is_in_group("player1"):
			$animalfriendcode.spitup(GameUtils.mouthValue)
		if is_in_group("player2"):
			$animalfriendcode.spitup(GameUtils.mouthValueP2)

##ability input call and inhale input
	if Input.is_action_just_pressed(A) && abilityCooldown == false && crouch == false:
		if canInhale == true && inhaling == false && hasAbility == false && swim == false:
			inhale()
		if swim == true && hasAbility == false:
			$animalfriendcode.bubbleblow()
		if hasAbility == true && is_in_group("player1"):
			ability(GameUtils.ABILITY)
		elif hasAbility == true && is_in_group("player2"):
			ability(GameUtils.ABILITYP2)
	#stop ability
	if Input.is_action_just_released(A) && abilitycanstop == true && hasAbility == true or Input.is_action_just_released(A) && swim == true && activeAbility == 0:
		$animalfriendcode.abilityStop()
	
#stop inhaling
	if Input.is_action_just_released(A) && hasAbility == false && swim == false:
		abilityCooldown = true
		if frenval != 1:
			overrideX = true
		$abilityCooldown.set_wait_time(0.3)
		$abilityCooldown.start()
		await get_tree().create_timer(0.3).timeout
		inhaleStop()
	if Input.is_action_pressed(A) && mouthFull == true:
		inhaleStop()

#handles the long jump release time
	if event.is_action_released(JUMP) && is_jumping:
		jump_timer = jump_time_max
		
#handles multijump
	if Input.is_action_just_pressed(JUMP) && is_jumping == true && jumpCooldown == false && hurt == false && swim == false:
		$animalfriendcode.multijump()
	
	if Input.is_action_just_pressed(SELECT) && hasAbility == true && crouch == false && canInhale == true:
		$projectileProducer.projectShoot($animalfriendcode.dropabilitystar)

#double tap to run checker
	if Input.is_action_just_released(RIGHT) or Input.is_action_just_released(LEFT):
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
#############################################################################
#i n p u t p r o c e s s e s
	if crouch == false && overrideY == false && swim == false:
		#handles jump input and calls jump function
		if Input.is_action_pressed(JUMP) && is_jumping == false && canJump == true && overrideX == false && falling == false:
			$animalfriendcode.jump()
		#while jump is held, jumptimer increases
		if Input.is_action_pressed(JUMP) && is_jumping == true && jump_timer < jump_time_max:
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)

	if crouchOverride == false:
		if Input.is_action_pressed(DOWN) && $animalfriendcode.bubblestart == true && is_on_floor():
			docrouch()
		if Input.is_action_just_released(DOWN) && crouch == true:
			uncrouch()
#inhale stop contingency
	if inhaling == true && mouthFull == true:
		inhaleStop()

func _physics_process(delta):
	var directionv = Input.get_axis(UP, DOWN) #vertical direction. for swimming
	var direction = Input.get_axis(LEFT, RIGHT) #horizontal direction
	#swimming direction parameters
	if overrideX == false && swim == true && mouthFull == false or overrideX == false && swim == true && frenval == 4:
		if Input.is_action_pressed(JUMP):
			swimphys(-50,1,4)
		if directionv == -1 or directionv == 1:
			DIRV = directionv
			swimphys(50,directionv,4)
		if directionv == 0 && direction != 0 or directionv == null && direction != null:
			swimphys(0,1,1)
		if directionv == 0 && direction == 0 or directionv == null && direction == null:
			swimphys(10,1,1)
	if swim == true && mouthFull == true && frenval != 4:
		swimphys(20,1,4) # sink while mouthFull

	#directional parameters
	if direction == -1 && overrideX == false or direction == 1 && overrideX == false:
		DIR = direction
	if direction && overrideX == false:
		velocity.x = move_toward(velocity.x, SPEED * direction, SPEEDELTA)
		cancheckrun = true
	if direction == 0 or direction == null:
		#this line will be contingecnies where kirby should not stop moving while idle
		if activeAbility == 0:
			velocity.x = move_toward(velocity.x, 0, 7)
			if cancheckrun == true:
				cancheckrun = false
				$runCooloff.start()
	#speed parameters run / mouthful / etc
	if overrideX == false: #this stops the whole override x form breaking
		if run == true && mouthFull == false:
			SPEED = 123
			SPEEDELTA = 5
		elif run == true && mouthFull == true:
			SPEED = 96
			SPEEDELTA = 5
		elif mouthFull == true && run == false:
			SPEED = 60
			SPEEDELTA = 4
		if flight == true or swim == true:
			SPEED = 70
			SPEEDELTA = 4
		if run == false && flight == false:
			SPEED = 80
			SPEEDELTA = 4
	if swim == false:
		groundphys(delta)
	move_and_slide()

func swimphys(vspeed,directionv,vdelta):
	velocity.y = move_toward(velocity.y, vspeed * directionv, vdelta)

func groundphys(delta):
	# Add the gravity.
	if not is_on_floor() && overrideY == false:
		jump_timer += delta
		$animalfriendcode.fallphysics()

#landing parameters
	if is_on_floor() && crouch == false:
		landed()
#squishes/boucnes when hits wall. 
#max angle was set to 50' so to not collide with slopes
	if is_on_wall() && falling == false && run == true:
		run = false
		squish = true

func landed():
	falling = false
	flight = false
	canJump = true
	jump_timer = 0.0
	is_jumping = false

func apply_jump_force(power):
	velocity.y = power

func inhale():
	$animalfriendcode.inhale()
	canInhale = false
	inhaling = true
	$projectileProducer.projectFollow($animalfriendcode.suckScene)

func inhaleStop():
	inhaling = false
	canJump = true
	canInhale = true
	overrideX = false
	abilityCooldown = true
	$"abilityCooldown".set_wait_time(0.1)
	$"abilityCooldown".start()

func docrouch():
	if mouthFull == true:
		swallow()
	if is_on_floor():
		velocity.x = 0
		crouch = true
		overrideX = true
		canJump = false
		canInhale = false
		$normalhitbox.call_deferred("set", "disabled", true)
	
func uncrouch():
	crouch = false
	overrideX = false
	canInhale = true
	canJump = true
	$normalhitbox.call_deferred("set", "disabled", false)

func swallow():
	canInhale = true
	if is_in_group("player1") && GameUtils.HELDABILITY >= 0:
		GameUtils.ABILITY = GameUtils.HELDABILITY
		GameUtils.mouthValue = 1
		Hud.updateability()
	if is_in_group("player2") && GameUtils.HELDABILITYP2 >= 0:
		GameUtils.ABILITYP2 = GameUtils.HELDABILITYP2
		GameUtils.mouthValueP2 = 1
		Hud.updateability2()
	if is_in_group("player1") && GameUtils.HELDABILITY == -1:
		GameUtils.mouthValue = 1
		$damDect.damage()
	if is_in_group("player2") && GameUtils.HELDABILITYP2 == -1:
		GameUtils.mouthValueP2 = 1
		$damDect.damage()
	mouthFull = false

func spitCascade():
	spit = true
	$abilityCooldown.set_wait_time(0.5)
	$abilityCooldown.start()
	$globalvars.mouthvalset(1)
	overrideX = true
	abilityCooldown = true
	mouthFull = false
	velocity.x = 0
	flight = false
	await get_tree().create_timer(0.3).timeout
	spit = false
	overrideX = false
	abilityCooldown = false
	canInhale = true
	canJump = true

func heal(v):
	if is_in_group("player1"):
		GameUtils.HEALTH += v
		Hud.updatehp()
	if is_in_group("player2"):
		GameUtils.HEALTHP2 += v
		Hud.updatehp2()

func ability(abilityScore):
	if abilityScore == 1:
		$animalfriendcode.fire()
	if abilityScore == 2:
		$animalfriendcode.shock()
	if abilityScore == 3:
		$animalfriendcode.ice()
	if abilityScore == 4:
		$animalfriendcode.stone()
	if abilityScore == 5:
		$animalfriendcode.spike()
	if abilityScore == 6:
		$animalfriendcode.cutter()
	if abilityScore == 7:
		$animalfriendcode.parasol()
	if abilityScore == 8:
		$animalfriendcode.broom()
