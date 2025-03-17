extends CharacterBody2D

var SPEED = 80.0
var SPEEDELTA = 4

var frenval #this isnt used for anything???
var friendlist = []

var overrideX = false
var overrideY = false

var normaldamageguard = false
var hurt = false
var iframes = false

#jumps^^^^^^^^^^^^^^^^^^^^^^^
var is_jumping = false
var canJump = true
var jumpMax = GameUtils.JUMPMAX
var jumpCount = 0
const JUMP_VELOCITY_STEP = 0.04
var jump_power_initial = -120
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

var swim = false
var falling = false
var flight = false
var squish = false

var iceskate = false
var iceabilityready = false
var parafloat = false
var parasolup = true
var parasolspawn = false

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

var UP = ""
var DOWN = ""
var LEFT = ""
var RIGHT = ""

var A = ""
var JUMP = ""
var C = ""
var SELECT = ""
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
		parasolspawn = false
#handles the long jump release time
	if event.is_action_released(JUMP) && is_jumping:
		jump_timer = jump_time_max
	
	#inhale input and function call
	if Input.is_action_just_pressed(A) && abilityCooldown == false && slide == false:
		if canInhale == true && hasAbility == false && swim == false && crouch == false:
			$projectileProducer.inhale()
		if swim == true && hasAbility == false && crouch == false:
			$projectileProducer.bubbleblow()
	##ability input call
		if hasAbility == true && is_in_group("player1"):
			$projectileProducer.ability(GameUtils.ABILITY)
		elif hasAbility == true && is_in_group("player2"):
			$projectileProducer.ability(GameUtils.ABILITYP2)
	if Input.is_action_just_released(A) && abilitycanstop == true && hasAbility == true or Input.is_action_just_released(A) && swim == true && activeAbility == 0:
		$projectileProducer.abilityStop() # this stops abilities and bubble blowing
	
	if Input.is_action_just_pressed("c"):
		if friendlist:
			frenval = friendlist[0].frenval #sets the player's frenval equal to idlefrend's so that they summon teh correct friend
			swim = friendlist[0].swim
			get_parent().summonfren(self,frenval,swim) #summons friend with func in the player script
			friendlist[0].queue_free()
			self.queue_free()

#stop inhaling
	if Input.is_action_just_released(A) && hasAbility == false && swim == false:
		$AbilitySprites/abilityCooldown.set_wait_time(0.3)
		$AbilitySprites/abilityCooldown.start()
		await get_tree().create_timer(0.3).timeout
		$projectileProducer.inhaleStop()
	if Input.is_action_pressed(A) && mouthFull == true:
			$projectileProducer.inhaleStop()
	
#handles multijump
	if Input.is_action_just_pressed(JUMP) && is_jumping == true && jumpCount < jumpMax && jumpCooldown == false && canInhale == true && hurt == false && swim == false:
		mouthFullAir = true
		flight = true
		velocity.y = jump_power_initial - 20
		jumpCount += 1
		jumpCooldown = true
		$jumpcooldown.start()
	
	if Input.is_action_just_pressed(SELECT) && hasAbility == true && crouch == false && canInhale == true:
		$projectileProducer.projectShoot($projectileProducer.dropabilitystar)

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
		if Input.is_action_pressed(JUMP) && is_jumping == false && canJump == true && inhaling == false && falling == false:
			jump()
		#while jump is held, jumptimer increases
		if Input.is_action_pressed(JUMP) && is_jumping == true && jump_timer < jump_time_max:
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)
	
	if crouchOverride == false && slide == false && inhaling == false:
		if Input.is_action_pressed(DOWN) && $projectileProducer.bubblestart == true && is_on_floor():
			docrouch()
		if Input.is_action_just_released(DOWN) && crouch == true:
			uncrouch()
	# C button input
	if Input.is_action_just_pressed(C):
		#handles swallowing
		if mouthFull == true && hasAbility == false:
			swallow()
		#handles animal friend interactions
	#inhale stop contingency
	if inhaling == true && mouthFull == true:
		$projectileProducer.inhaleStop()
	jumpMax = GameUtils.JUMPMAX

func _physics_process(delta):
	var directionv = Input.get_axis(UP, DOWN) #vertical direction. for swimming
	var direction = Input.get_axis(LEFT, RIGHT) #horizontal direction
	#swimming direction parameters
	if overrideX == false && swim == true && mouthFull == false:
		if Input.is_action_pressed(JUMP):
			swimphys(-50,1,4)
		if directionv == -1 or directionv == 1:
			swimphys(50,directionv,4)
		if directionv == 0 && direction != 0 or directionv == null && direction != null:
			swimphys(0,1,1)
		if directionv == 0 && direction == 0 or directionv == null && direction == null:
			swimphys(10,1,1)
	if swim == true && mouthFull == true:
		swimphys(20,1,4) #sink while mouthFull

	#directional parameters
	if direction == -1 && overrideX == false or direction == 1 && overrideX == false:
		DIR = direction
	if direction && overrideX == false && slide == false && inhaling == false && activeAbility == 0:
		velocity.x = move_toward(velocity.x, SPEED * direction, SPEEDELTA)
		cancheckrun = true
	if direction == 0 or direction == null:
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

func swimphys(vspeed,directionv,vdelta): #the movement process for swim input
	mouthFullAir = false
	velocity.y = move_toward(velocity.y, vspeed * directionv, vdelta)

func groundphys(delta):
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
	if is_on_floor() && crouch == false && slide == false:
		landed()

#squishes/boucnes when hits wall. 
#max angle was set to 50' so to not collide with slopes
	if is_on_wall() && falling == false && run == true:
		run = false
		squish = true

func landed():
	if mouthFullAir == true:
		mouthFullAir = false
		$projectileProducer.projectShoot($projectileProducer.airpuff)
		$projectileProducer.spitCascade()
		jumpCooldown = true
		$jumpcooldown.start()
	falling = false
	flight = false
	canJump = true
	jumpCount = 0
	jump_timer = 0.0
	is_jumping = false

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
	mouthFullAir = false

func heal(v):
	if is_in_group("player1"):
		GameUtils.HEALTH += v
		Hud.updatehp()
	if is_in_group("player2"):
		GameUtils.HEALTHP2 += v
		Hud.updatehp2()
