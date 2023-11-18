extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -340.0
const JUMP_VELOCITY_STEP = 1
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var airpuff : PackedScene
@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var SlideHitbox : PackedScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene
@export var icecube : PackedScene


@onready var HPHUD = $CanvasLayer/HUD/HPbar
@onready var Starbar = $CanvasLayer/HUD/Starbar
@onready var enemyBar = $CanvasLayer/HUD/enemybar
@onready var abilitycard = $CanvasLayer/HUD/abilitycard

#####j###u###m###p###i###n###g#######################
var canJump = true
var jumpMax = GameUtils.JUMPMAX
var jumpCount = 0
var jump_power_initial = -150
var jump_power = 0
var jump_time_max = 0.2
var jump_timer = 0.0
var is_jumping = false
##############################################
var activeAbility = 0
var abilityCooldown = false
var abilitycanstop = true
var iceabilityready = true
var overrideY = false
var overrideX = false
var crouchOverride = false
var crouch = false
var canInhale = true
var mouthFull = false
var mouthFullAir = false
var collideCheck = false
##############################################
var invicandy = false
var canFloat = false
var frameFlashAni = false
var abilityAni = false
var idleAni = false
var hasAbility = false
var flight = false
var falling = false
var slide = false
###r##u###n###n##i##n##g####
var runCheckR = false
var runCheckL = false
var runcont = false
var run = false


var uiInputs = ["1","2","3","4","5","6","7","8"]
var hashTable = {
	"1":1,
	"2":2,
	"3":3,
	"4":4,
	"5":5,
	"6":6,
	"7":7,
	"8":8,
}

func _ready():
	$abilitySprites.visible=false
	WINDFORCEX = 0.0
	WINDFORCEY = 0.0

func _input(event):
	
	
	if Input.is_action_just_pressed("select"):
		dropstar()
	
	#jump input is handled in physics proccess
	
	#handles multijump
	if Input.is_action_just_pressed("b") && is_jumping == true && jumpCount < jumpMax && abilityCooldown == false && canInhale == true && $AnimatedSprite2D.animation != "hurt":
		mouthFullAir = true
		flight = true
		if jumpMax < 999:
			velocity.y = JUMP_VELOCITY + -100 + (40 * jumpCount)
		else:
			velocity.y = JUMP_VELOCITY + -60
		jumpCount += 1
		abilityCooldown = true
		$abilitySprites/abilityCooldown.set_wait_time(0.2)
		$abilitySprites/abilityCooldown.start()

#handles up button input
	if Input.is_action_pressed("up"):
	#lets player flaot with parasol
		if GameUtils.ABILITY == 7 && not is_on_floor():
			parafloat()

#handles down button input
	if Input.is_action_pressed("down"):
	#handles crouch button input
		if crouch == false && $AnimatedSprite2D.animation != "open":
			docrouch()
		if hasAbility == false:
			swallow()
	#this flaoting varaible is specifically for the parasol ability
		if canFloat == true:
			canFloat = false

#handles crouch release input
	if Input.is_action_just_released("down") && crouch == true && crouchOverride == false && slide == false:
		uncrouch()

#handles the long jump release time
	if event.is_action_released("b") && is_jumping:
		jump_timer = jump_time_max

#discription: discerning double tapping done with double diretection determining
#handles doulbe-tap running
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

#handles debug key inputs
#debugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebug
	if event.as_text() in uiInputs:
		GameUtils.ABILITY = hashTable[event.as_text()]
		abilitycard.update_ability_card(GameUtils.ABILITY)

	if Input.is_action_just_pressed("debug9"):
		hasAbility = false
		GameUtils.ABILITY = 0
		abilitycard.update_ability_card(GameUtils.ABILITY)
		mouthFull = true
		GameUtils.STARS += 1
		Starbar.update_stars(GameUtils.STARS)
		print("FULL")
		GameUtils.HEALTH += 1
		#this calls the HUD to update and display the new current HP
		HPHUD.update_health(GameUtils.HEALTH)
		
		GameUtils.mouthValue = 2

	if Input.is_action_just_pressed("debug0"):
		GameUtils.HEALTH = 1
		HPHUD.update_health(GameUtils.HEALTH)
		GameUtils.STARS = 1
		Starbar.update_stars(GameUtils.STARS)
#debugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebug

func _process(_delta):
	
#action inputs ____ A _____ B _____ C ____ A _____ B _____ C ____ A _____ B _____ C
#||  A  __   B   __  C  || 
#|| MB1 __ SPACE __ MB2 || 
#||  Z  __   X   __  C  || 
#||  J  __   K   __  L  ||

#handles inhale input
	if hasAbility == false && $AnimatedSprite2D.animation != "hurt" && mouthFullAir == false && crouch == false && not Input.is_action_pressed("down"):
		if Input.is_action_pressed("a") && canInhale == true && mouthFull == false:
			inhale()
		
		elif Input.is_action_pressed("a") && mouthFull == true:
			inhaleStop()
		elif Input.is_action_just_released("a") && canInhale == false:
			inhaleStop()
#handles spitting input
	if Input.is_action_just_pressed("a") && mouthFull == true or Input.is_action_just_pressed("a") && mouthFullAir == true:
	#makes sure you cant multi jump after spitting out air
		if mouthFullAir == true:
			jumpCount = GameUtils.JUMPMAX
		projectShoot(GameUtils.mouthValue)
		
		
#handles ability input
	elif hasAbility == true:
		if Input.is_action_pressed("a") && abilityCooldown == false && crouch == false && crouchOverride == false && mouthFullAir == false:
			ability(GameUtils.ABILITY)
		elif Input.is_action_just_released("a") && abilitycanstop == true:
			abilityStop()



#handles slidekick input
	if crouch == true && Input.is_action_just_pressed("b") && slide == false:
		slidekick()
#handles swallowing
	if Input.is_action_just_pressed("c") && mouthFull == true && hasAbility == false:
		swallow()
	
	
	
	
#FIX this enemybar breaks a lot of the time, need to fix
	enemyBar.update_enemy_bar(GameUtils.enemyHP)
	
	#if GameUtils.icecubespawn == true:
	#	summonice()
	
	
	
#sets kirby's max health at 10
	if GameUtils.HEALTH > 10:
		GameUtils.HEALTH = 10
	if GameUtils.HEALTH <= 0:
		die()
		
	if GameUtils.ABILITY > 1:
		hasAbility = true
	elif GameUtils.ABILITY <= 1:
		hasAbility = false
	
	if GameUtils.ABILITY > 0:
		hasAbility = true
	else:
		hasAbility = false
	
#rules for when something enters kirby's mouth
#BEFORE swallowing
#after inhaling
#mouthFull = true basically
	if GameUtils.mouthValue > 1:
		mouthFull = true
		jumpCount = jumpMax
		canInhale = false
		GameUtils.Killsuck = true
		overrideX = false

#this handles the visability of the normal animations, and the ability animations
	if abilityAni == true:
		$AnimatedSprite2D.visible=false
		$abilitySprites.visible=true
	elif abilityAni == false:
		$AnimatedSprite2D.visible=true
		$abilitySprites.visible=false

	#if abilityCooldown == false && activeAbility > 0:
	#	abilityStop()
#this stops kirby from moving while an ability is active and on the floor
#excludes the fire ability ( > 1)
#this is mostly for the parasol ability so kirb wont slide while moving
	if activeAbility > 1 && is_on_floor():
		velocity.x = 0
		overrideX = true
		overrideY = true
		velocity.y = 0

	if collideCheck == true:
		bodyEscape()

func _physics_process(delta):
	
	#add the gravity
	if not is_on_floor() && overrideY == false:
		canJump = false
		is_jumping = true
		if velocity.y < 200:
			velocity.y += gravity * delta
		#velocity.y = velocity.y * 0.97

		if flight == false && falling == false:
		#hanldes jump animations
			if mouthFull == false && $AnimatedSprite2D.animation != "hurt" && GameUtils.ABILITY != 7:
				$AnimatedSprite2D.play("jump")
			elif mouthFull == true && $AnimatedSprite2D.animation != "fat hurt" && GameUtils.ABILITY != 7:
				$AnimatedSprite2D.play("fat jump")
			if GameUtils.ABILITY == 7:
				$AnimatedSprite2D.play("parajump")
			falling = true
		elif flight == true:
			if Input.is_action_just_pressed("b"):
				if GameUtils.ABILITY != 7:
					$AnimatedSprite2D.play("flap")
				elif GameUtils.ABILITY == 7:
					$AnimatedSprite2D.play("paraflight")
			velocity.y = velocity.y * 0.86
			velocity.x = velocity.x * 0.75
		elif GameUtils.ABILITY == 7 && jumpCount >= jumpMax && canFloat == true:
			parafloat()

	if is_on_floor() && $AnimatedSprite2D.animation != "open" :
		canJump = true
		jumpCount = 0
		flight = false
		jump_timer = 0.0
		is_jumping = false
		canFloat = true
	#running animations
		if crouch == false && GameUtils.ABILITY != 7 && idleAni == false:
			if mouthFull == false:
				if run == false:
					$AnimatedSprite2D.play("walk")
				elif run == true:
					$AnimatedSprite2D.play("run")
			elif mouthFull == true:
				$AnimatedSprite2D.play("fat run")
		elif crouch == false && GameUtils.ABILITY == 7 && idleAni == false:
			$AnimatedSprite2D.play("pararun")
		
	#landing rules and animation
		if falling == true:
			spitOutAirPuff()
			idleAni = false
			overrideX = true
			if GameUtils.ABILITY != 7:
				if mouthFull == false:
					$AnimatedSprite2D.play("crouch")
				elif mouthFull == true:
					$AnimatedSprite2D.play("fat land")
			elif GameUtils.ABILITY == 7:
				$AnimatedSprite2D.play("paraidle")
			#await get_tree().create_timer(0.15).timeout
			overrideX = false
			falling = false
	else:
		jump_timer += delta
	
	#handles jump input and calls jump function
	if Input.is_action_pressed("b") && mouthFullAir == false && is_jumping == false && canJump == true && overrideY == false && crouch == false && canInhale == true && not Input.is_action_pressed("down"):
		jump()
	#while jump is hed, jumptimer increases
	elif Input.is_action_pressed("b") && is_jumping == true && overrideY == false && jump_timer < jump_time_max && canInhale == true:
		jump_power -= JUMP_VELOCITY_STEP
		apply_jump_force(jump_power)
	
	
	var direction = Input.get_axis("left","right")
	if direction == -1 and $AnimatedSprite2D.animation != "open" and activeAbility == 0:
		GameUtils.DIR = -1
		idleAni = false
		$AnimatedSprite2D.flip_h = true
		$abilitySprites.flip_h = true
		$projectileProducer.rotation_degrees = 180
		$projectileProducer.position.x = -8
	elif direction == 1 and $AnimatedSprite2D.animation != "open":
		GameUtils.DIR = 1
		idleAni = false
		$AnimatedSprite2D.flip_h = false
		$abilitySprites.flip_h = false
		$projectileProducer.rotation = 0
		$projectileProducer.position.x = 8
#handles movement veleocity and run speed
	if direction:
		if overrideX == false:
			velocity.x = direction * SPEED
			if run == true && mouthFull == false:
				velocity.x = velocity.x * 1.54
				$AnimatedSprite2D.set_speed_scale(1.5)
			elif run == true && mouthFull == true:
				velocity.x = velocity.x * 1.2
				$AnimatedSprite2D.set_speed_scale(1.5)
			elif mouthFull == true && run == false:
				velocity.x = velocity.x * 0.75
#handles idle and idle velocity
	else:
		if crouch == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 && idleAni == false && $AnimatedSprite2D.animation != "open" && is_on_floor():
				GameUtils.Killsuck = true
				$AnimatedSprite2D.set_speed_scale(1.0)
				if mouthFull == false && GameUtils.ABILITY != 7:
					$AnimatedSprite2D.play("idle")
					idleAni = true
				elif mouthFull == true && GameUtils.ABILITY != 7:
					$AnimatedSprite2D.play("fat idle")
					idleAni = true
				elif GameUtils.ABILITY == 7:
					$AnimatedSprite2D.play("paraidle")
					idleAni = true


#adds wind blowing force
	velocity.x += WINDFORCEX * (delta * 5)
	if activeAbility != 1: #contingency to make the fireability undisturbed during wind
		velocity.y += WINDFORCEY * (delta * 2.5)
#this if statement makes sure kirby doesnt fall through Y wind
	if WINDFORCEY != 0 && velocity.y > 90:
		velocity.y = 50
	move_and_slide()

func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false

func _on_run_cooloff_timeout():
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		run = false
		$AnimatedSprite2D.set_speed_scale(1.0)


func jump():
	if is_jumping == false:
		jump_timer = 0.0
		is_jumping = true
		apply_jump_force(jump_power_initial)
		jump_power = jump_power_initial

func apply_jump_force(power):
	velocity.y = power

#handles the crouch fucntion
func docrouch():
	if is_on_floor() && slide == false && activeAbility == 0:
		crouch = true
		overrideX = true
		$normalhitbox.call_deferred("set", "disabled", true)
		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", true)
		$AnimatedSprite2D.play("crouch")
		velocity.x = 0
func uncrouch():
	if crouchOverride == false:
		idleAni = false
		#await get_tree().create_timer(0.1).timeout
		overrideX = false
		$normalhitbox.call_deferred("set", "disabled", false)
		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", false)
		crouch = false




#########################################################################################
#need to write a function here for when kirby crouches with the parasol
func paragaurd():
	pass


func dropstar():
	if hasAbility == true:
		projectShoot(6)
		GameUtils.ABILITY = 0
		abilitycard.update_ability_card(GameUtils.ABILITY)
		hasAbility = false


#infinite recoursion?
func swallow():
	canInhale = true
	GameUtils.ABILITY = GameUtils.HELDABILITY
	abilitycard.update_ability_card(GameUtils.ABILITY)
	GameUtils.mouthValue = 1
	docrouch()
	#await get_tree().create_timer(0.1).timeout
	mouthFull = false
	mouthFullAir = false
	idleAni = false

func inhale():
	canJump = false
	GameUtils.Killsuck = true
	GameUtils.Killsuck = false
	projectFollow(1)
	if GameUtils.ABILITY != 7:
		$AnimatedSprite2D.play("open")
	elif GameUtils.ABILITY == 7:
		$AnimatedSprite2D.play("paraopen")
	velocity.x = 0
	canInhale = false
	overrideX = true
	if is_on_floor():
		overrideY = true
		velocity.y = 0

func inhaleStop():
	canJump = true
	GameUtils.Killsuck = true
	idleAni = false
	overrideX = false
	overrideY = false
	canInhale = true
	if mouthFull == true:
		$AnimatedSprite2D.play("fat jump")
	else:
		$AnimatedSprite2D.play("jump")


func slidekick():
	if abilityCooldown == false:
		slide = true
		GameUtils.Killsuck = false
		$AnimatedSprite2D.play("slide")
		projectFollow(2)
		velocity.x = GameUtils.DIR * 200
		await get_tree().create_timer(0.3).timeout
		velocity.x = GameUtils.DIR * 200
		GameUtils.Killsuck = true
		slide = false
		abilityCooldown = true
		$abilitySprites/abilityCooldown.set_wait_time(0.2)
		$abilitySprites/abilityCooldown.start()
		docrouch()
		if not Input.is_action_pressed("down"):
			uncrouch()


func spitCascade():
	GameUtils.mouthValue = 1
	idleAni = false
	abilityCooldown = true
	canInhale = false
	overrideX = true
	if GameUtils.ABILITY != 7:
		$AnimatedSprite2D.play("open")
	elif GameUtils.ABILITY == 7:
		$AnimatedSprite2D.play("paraopen")
	mouthFull = false
	mouthFullAir = false
	velocity.x = 0
	await get_tree().create_timer(0.1).timeout
	if not is_on_floor():
		if GameUtils.ABILITY != 7:
			$AnimatedSprite2D.play("jump")
		elif GameUtils.ABILITY == 7:
			$AnimatedSprite2D.play("parajump")
	elif is_on_floor():
		if GameUtils.ABILITY != 7:
			$AnimatedSprite2D.play("idle")
		elif GameUtils.ABILITY == 7:
			$AnimatedSprite2D.play("paraidle")
	overrideX = false
	flight = false
	falling = false
	await get_tree().create_timer(0.2).timeout
	abilityCooldown = false
	canInhale = true

func spitOutAirPuff():
	#shoots an airpuff projectile 1
	if mouthFullAir == true:
		await get_tree().create_timer(0.1).timeout
		projectShoot(1)
		spitCascade()

#summons projectiles that move independently from player
func projectShoot(v):
	var projectS
	if v == 1:
		projectS = airpuff.instantiate()
		spitCascade()
	elif v == 2:
		projectS = starFire.instantiate()
		spitCascade()
	elif v == 3:
		pass #put big star shoot here
		
	elif v == 4:
		projectS = iceAbilityBox.instantiate()
	elif v == 5:
		pass
		#probably sweep
	elif v == 6:
		projectS = dropabilitystar.instantiate()
	owner.add_child(projectS)
	projectS.transform = $projectileProducer.global_transform

#summons hitboxes that follow the player
#missing the owner.add_child() and the $pp.global_transform
func projectFollow(v):
	var projectF
	# 1 is the inhale ability project
	# uses killsuck to queue_free
	if v == 1:
		GameUtils.Killsuck = false
		canInhale = false
		projectF = suckScene.instantiate()
	# 2 is the kick slide hitbox.
	# uses killsuck to queue_free
	if v == 2:
		projectF = SlideHitbox.instantiate()
	# 3 is the fire abiltiy hitbox.
	if v == 3:
		projectF = fireAbilityBox.instantiate()
	if v == 4:
		projectF = shockAbilityBox.instantiate()
	add_child(projectF)
	projectF.transform = $projectileProducer.transform


func _on_wall_collide_detect_body_entered(body):
	if body.name == "maintiles":
		crouchOverride = true
		docrouch()

func _on_wall_collide_detect_body_exited(body):
	if body.name == "maintiles":
		crouchOverride = false
		
func _on_body_collide_detect_body_entered(body):
	if body.name == "maintiles":
		collideCheck = true
		print("COLLIDECHECK TRUEEEEEEEEEEEEEE")
		
		
func _on_body_collide_detect_body_exited(body):
	if body.name == "maintiles":
		collideCheck = false

func bodyEscape():
	if activeAbility != 1:
		overrideX = true
		overrideY = true
		$smallHitbox.call_deferred("set", "disabled", true)
		$normalhitbox.call_deferred("set", "disabled", true)
		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", true)
		velocity.y = -40
		await get_tree().create_timer(0.1).timeout
		overrideX = false
		overrideY = false
		$smallHitbox.call_deferred("set", "disabled", false)
		$normalhitbox.call_deferred("set", "disabled", false)
		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", false)


func die():
	velocity.x = 0
	velocity.y = -100
	GameUtils.Iframes = false
	GameUtils.IframeHit = false
	GameUtils.Killsuck = true
	overrideX = true
	overrideY = true
	$AnimatedSprite2D.play("dead")
	$smallHitbox.call_deferred("set", "disabled", true)
	$normalhitbox.call_deferred("set", "disabled", true)
	$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	velocity.y = 40

func _on_damage_detect_body_entered(body):
	if GameUtils.Iframes == false:
		if body.is_in_group("mobs") && activeAbility != 1:
			damage()
		elif body.is_in_group("hazard"):
			damage()

func damage():
	idleAni = false
	activeAbility = 0
	GameUtils.Killsuck = true
	GameUtils.IframeHit = true
	mouthFullAir = false
	flight = false
	overrideX = false
	overrideY = false
	abilityAni = false
	if GameUtils.Iframes == false:
		abilityStop()
		GameUtils.Killsuck = true
		#makes sure it doesn spam the animation
		if frameFlashAni == false:
			$frameflash.start()
		$IframeTimer.set_wait_time(2.0)
		$IframeTimer.start()
		canInhale = false
		overrideX = true
		#updates the player's actual HP
		GameUtils.HEALTH -= 1
		#this calls the HUD to update and display the new current HP
		HPHUD.update_health(GameUtils.HEALTH)
		if mouthFull == false:
			$AnimatedSprite2D.play("hurt")
		elif mouthFull == true:
			$AnimatedSprite2D.play("fat hurt")
		velocity.x = SPEED * GameUtils.DIR * -1.75
		velocity.y = -200
		await get_tree().create_timer(0.5).timeout
		GameUtils.IframeHit = true
		GameUtils.Iframes = true
		
		#this is a contingency where it starts the suck animation again after being hit
		canInhale = true
		if Input.is_action_pressed("a") && hasAbility == false:
			inhale()

func _on_iframe_timer_timeout():
	canInhale = false
	frameFlashAni = false
	GameUtils.Iframes = false
	GameUtils.IframeHit = false
	$frameflash.stop()
	$AnimatedSprite2D.show()
	
#handles the flashign animation when Iframes are active
func _on_frameflash_timeout():
	frameFlashAni = true
	if abilityAni == false:
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.show()
	elif abilityAni == true:
		$abilitySprites.hide()
		await get_tree().create_timer(0.2).timeout
		$abilitySprites.show()

func ability(abilityScore):
	#uses the hasAbility variable
	#under the press A statement
	#$abilitySprites.visible=true
	#$AnimatedSprite2D.visible=false
	abilityAni = true
	
	#abilityScore 1 is Fire
	if abilityScore == 1:
		abilitycanstop = false
		activeAbility = 1
		velocity.y = 0
		set_floor_max_angle(0.05)
		overrideX = true
		overrideY = true
		$smallHitbox.disabled=true
		$abilitySprites/abilityCooldown.set_wait_time(1.0)
		$abilitySprites/abilityCooldown.start()
		abilityCooldown = true
		$abilitySprites.play("fireStart")
		GameUtils.KillAbility = false
		projectFollow(3)
		velocity.x = 230 * GameUtils.DIR
		await $abilitySprites.animation_finished
		$abilitySprites.play("fireLoop")
		await $abilitySprites.animation_finished
		abilitycanstop = true
		GameUtils.KillAbility = true
		$smallHitbox.disabled=false
		overrideX = true
		$AnimatedSprite2D.play("open")
		mouthFull = false
		mouthFullAir = false
		velocity.x = 0
		await get_tree().create_timer(0.1).timeout
		overrideX = false
		overrideY = false
		crouchOverride = false
		flight = false
		falling = false
		$abilitySprites/abilityCooldown.set_wait_time(0.25)
		$abilitySprites/abilityCooldown.start()
		abilityCooldown = true
		set_floor_max_angle(1)
		abilityAni = false
		activeAbility = 0

#ability score 2 is shock
#this is not! broken
	elif abilityScore == 2:
		if activeAbility == 0:
			abilitycanstop = true
			GameUtils.KillAbility = true
			GameUtils.KillAbility = false
			projectFollow(4)
			activeAbility = 2
		elif activeAbility == 2:
			$abilitySprites.play("shockLoop")

#ability score 3 is ice, 
	elif abilityScore == 3:
		if activeAbility == 0:
			$abilitySprites/iceabilityCooldown.start()
			iceabilityready = false
			activeAbility = 3
			$abilitySprites.play("iceStart")
			await $abilitySprites.animation_finished
			$abilitySprites.play("iceLoop")
			abilitycanstop = true
		if iceabilityready == true:
			#4 is the score for ice
			projectShoot(4)
			iceabilityready = false
		
	
	elif abilityScore == 4:
		pass
	
	elif abilityScore == 5:
		pass
	
	elif abilityScore == 6:
		pass
#abilityscore 7 is the parasol
	elif abilityScore == 7:
		abilitycanstop = false
		activeAbility = 7
		canFloat = false
		flight = false
		$abilitySprites.play("parasol")
		#create atack projectile
		await $abilitySprites.animation_finished
		overrideX = false
		abilitycanstop = true
		abilityCooldown = true
		abilityStop()
		print("parasol!!!")
	
func _on_ability_cooldown_timeout():
	abilityCooldown = false

func abilityStop():
	await get_tree().create_timer(0.1).timeout
	$smallHitbox.call_deferred("set", "disabled", false)
	#$AnimatedSprite2D.play("idle")
	set_floor_max_angle(1)
	activeAbility = 0
	GameUtils.KillAbility = true
	abilityAni = false
	velocity.x = 0
	overrideX = false
	overrideY = false
	$abilitySprites/iceabilityCooldown.stop()
	$abilitySprites/abilityCooldown.set_wait_time(0.25)
	$abilitySprites/abilityCooldown.start()
	abilityCooldown = true

func _on_iceability_cooldown_timeout():
	iceabilityready = true

func parafloat():
	if canFloat == true && flight == true:
		mouthFullAir = false
		flight = true
		$AnimatedSprite2D.play("parafloat")
		velocity.y = velocity.y * 0.86
		velocity.x = velocity.x * 0.75

#func summonice():
#	var icecubespawn = icecube.instantiate()
#this here uses call deffered to summon the icecube, godot just told me to use this instead idky
#	owner.add_child(icecubespawn)
#	icecubespawn.transform = $projectileProducer.global_transform
#	GameUtils.icecubespawn = false
