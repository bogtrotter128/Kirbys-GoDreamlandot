extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var marker = $ProjectileProducer

#NEW PLAYER SCRIPT x4
var SPEED = 80.0
var SPEEDELTA = 4
var FRICTION = 6
var SPEEDMOD = 1

#coyote time
var coyote_frames = 6  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not

#movement
var overrideX = false
var overrideY = false
var DIR = 1
var swim = false
var walk = false
var is_falling = false
var flight = false
var haslanded = false

###r##u###n###n##i##n##g####
var runCheckR = false
var runCheckL = false
var runcont = false
var run = false
var cancheckrun = false

#jump
var canjump = true
var is_jumping = false
var jumpMax = GameUtils.JUMPMAX
var jumpCount = 0
const JUMP_VELOCITY_STEP = 0.04
var jump_power_initial = -120
var jump_power = 0
var jump_time_max = 0.3
var jump_timer = 0.0
var jumpCooldown = false

#crouch
var crouch = false
var crouchOverride = false
var canslide = true
var slide = false
var slide_time_max = 0.3
var slide_timer = 0.0

#ability
var mouthfull = false
var mouthfullair = false
var ability = 0
var abilitycanstop = true
var abilityActive = false
var abilityCooldown = false
var parasol = false

#animations
var anistate = "" #"fat", "para", "paraflight" ,and "flight"
var turn = false

#control
var UP = ""
var DOWN = ""
var LEFT = ""
var RIGHT = ""
var A = ""
var JUMP = ""
var C = ""
var SELECT = ""

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
	$CoyoteTimer.wait_time = coyote_frames / 60.0

func _unhandled_input(event):
	if Input.is_action_just_pressed(LEFT) && DIR == 1:
		turnanimation()
	elif Input.is_action_just_pressed(RIGHT) && DIR == -1:
		turnanimation()
	#double tap to run checker
	if Input.is_action_just_released(RIGHT) or Input.is_action_just_released(LEFT):
		$runCooloff.start()
		if Input.is_action_just_released(RIGHT):
			runCheckR = true
			$doubletap.start()
		elif Input.is_action_just_released(LEFT):
			runCheckL = true
			$doubletap.start()
	if !is_falling && !overrideX && !swim && ((runCheckR or runCheckL) or runcont == true):
		if Input.is_action_pressed(RIGHT) or Input.is_action_pressed(LEFT):
			run = true
	
	#jump release
	if event.is_action_released(JUMP) && (is_jumping or slide):
			jump_timer = jump_time_max
			slide_timer = slide_time_max
			slide = false
	#handles multijump
	if Input.is_action_just_pressed(JUMP) && is_jumping == true && jumpCount < jumpMax && jumpCooldown == false && overrideY == false:
		mouthfullair = true
		flight = true
		velocity.y = jump_power_initial - 20
		jumpCount += 1
		jumpCooldown = true
		$jumpcooldown.start()
	#crouching input
	if Input.is_action_pressed(DOWN) && !swim && !crouch && (!is_falling or coyote):
		docrouch()
	if Input.is_action_just_released(DOWN) && !swim && crouch && !crouchOverride:
		uncrouch()

func _physics_process(delta):
	var directionv = Input.get_axis(UP, DOWN) #vertical direction. for swimming
	var directionh = Input.get_axis(LEFT, RIGHT) #horizontal direction
	#directional movement
	if overrideX == false && directionh != 0:
		DIR = directionh
		sprite.flip_h = true if DIR == -1 else false
		walk = true
		movespeedmod()
		velocity.x = move_toward(velocity.x, (SPEED * SPEEDMOD) * directionh, SPEEDELTA)
	#no movement
	if directionh == 0 or overrideX:
		walk = false
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	if swim:
		swimphys(SPEED,directionv,SPEEDELTA)
		swimanimations(directionv)
	if !swim:
		groundphys(delta)
		if !is_falling:
			groundanimations()
		elif is_falling:
			flightanimations()
	move_and_slide()

func swimphys(vspeed,directionv,vdelta): #the movement process for swim input
#	mouthFullAir = false
	velocity.y = move_toward(velocity.y, vspeed * directionv, vdelta)
	swimanimations(directionv)

func groundphys(delta):
	#gravity
	if is_falling && overrideY == false:
		#but can still multijump\/
		is_jumping = true
		if flight == false:
			velocity.y = move_toward(velocity.y, 200, 7)
		elif flight == true:
			velocity.y = move_toward(velocity.y, 40, 7)
	#jump/slide input
	if Input.is_action_pressed(JUMP):
		if !is_jumping && canjump && (!is_falling or coyote) && !jumpCooldown && !overrideY:
			jump()
		if crouch && !slide && canslide:
			crouchslide()
	if Input.is_action_pressed(JUMP):
		#while jump is held, timer increases
		if is_jumping && !overrideY && !slide && jump_timer < jump_time_max:
			jump_timer += delta
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)
		#jolding slide. uses jump_power but for velocity.x
		if slide && slide_timer < slide_time_max: 
			jump_power -= (JUMP_VELOCITY_STEP * DIR)
			slide_timer += delta * 1.25
			apply_slide_force(jump_power)
	
	is_falling = !is_on_floor() #used to check coyote time
	if !is_falling && !haslanded: #landing parameters
		landed()
	if is_falling:
		haslanded = false
		if !is_jumping:
			coyote = true
			$CoyoteTimer.start()
	
func movespeedmod():
	if run:
		SPEEDMOD = 1.5
	elif flight:
		SPEEDMOD = 0.6
	elif swim:
		SPEEDMOD = 0.8
	else:
		SPEEDMOD = 1

func jump():
	is_jumping = true
	jumpCooldown = true
	$jumpcooldown.start()
	jump_timer = 0.0
	apply_jump_force(jump_power_initial)
	jump_power = jump_power_initial

func apply_jump_force(power):
	velocity.y = power

func apply_slide_force(power):
	velocity.x = power

func docrouch():
#	if mouthFull == true:
#		swallow()
	crouch = true
	run = false
	overrideX = true
	canjump = false
#	canInhale = false
	$normalhitbox.call_deferred("set", "disabled", true)
	
func uncrouch():
	crouch = false
	slide = false
	slide_timer = 0.0
	overrideX = false
	canjump = true
#	canInhale = true
	$normalhitbox.call_deferred("set", "disabled", false)
	
func crouchslide(): #reuses the jump time/power variables
	slide = true
	canslide = false
	slide_timer = 0.0
	$slidecooldown.start()
	apply_slide_force(200 * DIR)
	jump_power = (200 * DIR)

func landed():
	print("land")
	haslanded = true
	if mouthfullair == true:
		mouthfullair = false
#		$projectileProducer.projectShoot($projectileProducer.airpuff)
#		$projectileProducer.spitCascade()
#	jumpCooldown = true   <
#	$jumpcooldown.start() < make a part of spit cascade
	anistate = ""
	flight = false
	jumpCount = 0
	jump_timer = 0.0
	is_jumping = false

#animationsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
func groundanimations():
	if mouthfull:
		anistate = "fat"
	elif parasol:
		anistate = "paraflight" if flight else "para"
	else:
		anistate = ""
	
	if !crouch && !turn:
		if run:
			sprite.set_speed_scale(1.5)
			if self.is_in_group("player1"):
				sprite.play("run")
		else:
			sprite.set_speed_scale(1.0)
		if walk && !run:
			sprite.play(str(anistate)+"walk")
		if !walk:
			sprite.play(str(anistate)+"idle")
	if crouch && !turn:
		if !slide:
			sprite.play("crouch")
		if slide:
			sprite.play("slide")
func flightanimations():
	if flight:
		anistate = "flight"
	if !flight:
		sprite.play(str(anistate)+"jump")
	if flight && Input.is_action_just_pressed(JUMP) && !turn:
		sprite.play("flap")
		await sprite.animation_finished
		sprite.play(str(anistate))
	if flight && sprite.animation != "flap" && !turn:
		sprite.play(str(anistate))

func swimanimations(ver):
	if ver == 0:
		sprite.play("swim")
	if ver == -1:
		sprite.play("swim up")
	if ver == 1:
		sprite.play("swim down")

func turnanimation():
	if sprite.animation != (str(anistate)+"jump"):
		turn = true
		sprite.stop()
		sprite.play(str(anistate)+"turn")
		await get_tree().create_timer(0.13).timeout
		turn = false

func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false
func _on_run_cooloff_timeout():
	if not Input.is_action_pressed(RIGHT) and not Input.is_action_pressed(LEFT):
		run = false
		cancheckrun = true
func _on_coyote_timer_timeout():
	coyote = false
func _on_jumpcooldown_timeout():
	jumpCooldown = false
func _on_slidecooldown_timeout():
	canslide = true
