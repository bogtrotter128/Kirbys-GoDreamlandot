extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -340.0
const JUMP_VELOCITY_STEP = 7
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var airpuff : PackedScene
@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var SlideHitbox : PackedScene
@export var fireAbilityBox : PackedScene

@onready var HPHUD = $CanvasLayer/HUD/HPbar
@onready var Starbar = $CanvasLayer/HUD/Starbar
@onready var enemyBar = $CanvasLayer/HUD/enemybar
@onready var abilitycard = $CanvasLayer/HUD/abilitycard

#####j###u###m###p###i###n###g#######################
var jumpMax = 3
var jumpCount = 0
var jump_power_initial = -150
var jump_power = 0
var jump_time_max = 0.16
var jump_timer = 0.0
var is_jumping = false
##############################################
var abilityCooldown = false
var overrideY = false
var overrideX = false
var crouch = false
var canInhale = true
var mouthFull = false
var mouthFullAir = false
var crouchOverride = false
var collideCheck = false
##############################################
var activeAblity = 0
var frameFlashAni = false
var abilityAni = false
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

func _input(event):
	
#handles jump input and calls jump function
	if Input.is_action_pressed("b") && not Input.is_action_pressed("down"):
		jump()
		is_jumping = true
		if Input.is_action_pressed("b") && is_jumping == true && jump_timer < jump_time_max:
			jump_power -= JUMP_VELOCITY_STEP
			apply_jump_force(jump_power)

	#handles multijump
		if Input.is_action_just_pressed("b") && is_jumping == true && jumpCount < jumpMax && $AnimatedSprite2D.animation != "hurt":
			mouthFullAir = true
			flight = true
			velocity.y = JUMP_VELOCITY + -100 + (40 * jumpCount)
			jumpCount += 1

#handles crouch button input
	if Input.is_action_pressed("down") and $AnimatedSprite2D.animation != "open":
		docrouch()

#handles crouch release input
	if Input.is_action_just_released("down"):
		uncrouch()

#handles the long jump release time
	if event.is_action_released("b") && is_jumping:
		jump_timer = jump_time_max

#handles doulbe-tap running
	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		dbtap()

#action inputs ____ A _____ B _____ C ____ A _____ B _____ C ____ A _____ B _____ C
#||  A  __  B   __  C  || 
#|| MB1 __SPACE __ MB2 || 
#||  Z  __  X   __  C  || 
#||  J  __  K   __  L  ||

#handles inhale input
	if hasAbility == false && $AnimatedSprite2D.animation != "hurt" && crouch == false:
		if Input.is_action_pressed("a") && canInhale == true && mouthFull == false:
			inhale()
		elif canInhale == false or mouthFull == true:
			GameUtils.Killsuck = true
			overrideX = false
			overrideY = false
			canInhale = true
			$AnimatedSprite2D.play("idle")
#handles spitting input
	if Input.is_action_just_pressed("a") && mouthFull == true:
		projectShoot(GameUtils.mouthValue)
		
#handles ability input
	elif hasAbility == true:
		if Input.is_action_pressed("a") && overrideX == false && mouthFullAir == false:
			ability(GameUtils.ABILITY)
		elif Input.is_action_just_released("a"):
			abilityStop()



#handles slidekick input
	if crouch == true && Input.is_action_just_pressed("b") && slide == false:
		slidekick()

	if Input.is_action_just_pressed("c") && mouthFull == true && hasAbility == false:
		swallow()

#handles debug key inputs
#debugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebug
	if event.as_text() in uiInputs:
		GameUtils.ABILITY = hashTable[event.as_text()]
		abilitycard.update_ability_card(GameUtils.ABILITY)

	if Input.is_action_just_pressed("debug9"):
		await get_tree().create_timer(0.2).timeout
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
		
		GameUtils.mouthValue += 1
		await get_tree().create_timer(0.2).timeout

	if Input.is_action_just_pressed("debug0"):
		GameUtils.HEALTH = 1
		HPHUD.update_health(GameUtils.HEALTH)
		GameUtils.STARS = 1
		Starbar.update_stars(GameUtils.STARS)
#debugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebugdebug

func _process(_delta):
	
#FIX this enemybar breaks a lot of the time, need to fix
	enemyBar.update_enemy_bar(GameUtils.enemyHP)
	
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

	if abilityCooldown == false && activeAblity > 0:
		abilityStop()


	if collideCheck == true:
		bodyEscape()

func _physics_process(delta):
	
	#add the gravity
	if not is_on_floor() && overrideY == false:
		jump_timer += delta
		velocity.y += gravity * delta
		velocity.y = velocity.y * 0.97

		if flight == false && falling == false:
		#hanldes jump animations
			if mouthFull == false and $AnimatedSprite2D.animation != "hurt":
				$AnimatedSprite2D.play("jump")
			elif mouthFull == true and $AnimatedSprite2D.animation != "fat hurt":
				$AnimatedSprite2D.play("fat jump")
			falling = true
	if flight == true:
		if Input.is_action_just_pressed("b"):
			$AnimatedSprite2D.play("flap")
		velocity.y = velocity.y * 0.86
		velocity.x = velocity.x * 0.75

	if is_on_floor() && $AnimatedSprite2D.animation != "open" :
		jumpCount = 0
		flight = false
		jump_timer = 0.0
		is_jumping = false
	#running animations
		if run == false and mouthFull == false:
			$AnimatedSprite2D.play("walk")
		elif run == true and mouthFull == false:
			$AnimatedSprite2D.play("run")
		elif mouthFull == true:
			$AnimatedSprite2D.play("fat run")
		
	#landing rules and animation
		if falling == true:
			spitOutAirPuff()
			overrideX = true
			if mouthFull == false:
				$AnimatedSprite2D.play("crouch")
			elif mouthFull == true:
				$AnimatedSprite2D.play("fat land")
			await get_tree().create_timer(0.15).timeout
			overrideX = false
			falling = false

	var direction = Input.get_axis("left","right")
	if direction == -1 and $AnimatedSprite2D.animation != "open":
		$AnimatedSprite2D.flip_h = true
		$abilitySprites.flip_h = true
		GameUtils.DIR = -1
		$projectileProducer.rotation_degrees = 180
		$projectileProducer.position.x = -8
	elif direction == 1 and $AnimatedSprite2D.animation != "open":
		GameUtils.DIR = 1
		$AnimatedSprite2D.flip_h = false
		$abilitySprites.flip_h = false
		$projectileProducer.rotation = 0
		$projectileProducer.position.x = 8
#handles movement veleocity and run speed
	if overrideX == false:
		if direction:
			velocity.x = direction * SPEED
			if run == true:
				velocity.x = velocity.x * 1.64
			if mouthFull == true:
				velocity.x = velocity.x * 0.75
#handles idle and idle velocity
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 && $AnimatedSprite2D.animation != "open":
#maybe need a contingency^ here^ for when inhale animation plays
				if mouthFull == false:
					$AnimatedSprite2D.play("idle")
				elif mouthFull == true:
					$AnimatedSprite2D.play("fat idle")
	move_and_slide()

#discription: discerning double tapping done with double diretection determining
func dbtap():
	if falling == false:
		$runCooloff.start()
		if Input.is_action_just_released("right"):
			runCheckR = true
			$doubletap.start()
		if Input.is_action_just_released("left"):
			runCheckL = true
			$doubletap.start()
	if runCheckR == true or runcont == true:
		if Input.is_action_pressed("right"):
			run = true
	if runCheckL == true or runcont == true:
		if Input.is_action_pressed("left"):
				run = true

func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false

func _on_run_cooloff_timeout():
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		run = false


func jump():
	if overrideY == false:
		if is_jumping == false:
			jump_timer = 0.0
			apply_jump_force(jump_power_initial)
			jump_power = jump_power_initial

func apply_jump_force(power):
	velocity.y = power

func docrouch():
	if is_on_floor():
		crouch = true
		overrideX = true
		$normalhitbox.call_deferred("set", "disabled", true)
		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", true)
		if slide == false:
			$AnimatedSprite2D.play("crouch")
			velocity.x = 0

func uncrouch():
	if crouch == true && crouchOverride && slide== false:
		await get_tree().create_timer(0.1).timeout
		overrideX = false
		$normalhitbox.call_deferred("set", "disabled", false)
		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", false)
		crouch = false

#infinite recoursion?
func swallow():
	canInhale = true
	GameUtils.ABILITY = GameUtils.HELDABILITY
	abilitycard.update_ability_card(GameUtils.ABILITY)
	GameUtils.mouthValue = 1
	docrouch()
	await get_tree().create_timer(0.1).timeout
	mouthFull = false
	mouthFullAir = false

func inhale():
	GameUtils.Killsuck = false
	projectFollow(1)
	$AnimatedSprite2D.play("open")
	velocity.x = 0
	canInhale = false
	overrideX = true
	if is_on_floor():
		overrideY = true

func slidekick():
	if abilityCooldown == false:
		slide = true
		GameUtils.Killsuck = false
		$AnimatedSprite2D.play("slide")
		projectFollow(2)
		velocity.x = GameUtils.DIR * 200
		await get_tree().create_timer(0.2).timeout
		velocity.x = GameUtils.DIR * 200
		GameUtils.Killsuck = true
		await get_tree().create_timer(0.1).timeout
		slide = false
		abilityCooldown = true
		$abilitySprites/abilityCooldown.set_wait_time(0.2)
		$abilitySprites/abilityCooldown.start()
		docrouch()
		uncrouch()


func spitCascade():
	GameUtils.mouthValue = 1
	canInhale = false
	overrideX = true
	$AnimatedSprite2D.play("open")
	mouthFull = false
	mouthFullAir = false
	velocity.x = 0
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.play("idle")
	canInhale = true
	overrideX = false
	flight = false
	falling = false

func spitOutAirPuff():
	#shoots an airpuff projectile 1
	if mouthFullAir == true:
		projectShoot(1)
		spitCascade()

#summons projectiles that move independently from player
func projectShoot(v):
	var projectS
	if v == 1:
		projectS = airpuff.instantiate()
		spitCascade()
	if v == 2:
		projectS = starFire.instantiate()
		spitCascade()
		
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
	if v == 3:
		projectF = fireAbilityBox.instantiate()
	add_child(projectF)
	projectF.transform = $projectileProducer.transform


func _on_wall_collide_detect_body_entered(body):
	if body.name == "maintiles":
		crouch = true
		crouchOverride = true
		overrideX = true

func _on_wall_collide_detect_body_exited(body):
	if body.name == "maintiles":
		overrideX = false
		#crouch = false
		#crouchOverride = false
func _on_body_collide_detect_body_entered(body):
	if body.name == "maintiles":
		collideCheck = true
		print("COLLIDECHECK TRUEEEEEEEEEEEEEE")
		
		
func _on_body_collide_detect_body_exited(body):
	if body.name == "maintiles":
		collideCheck = false

func bodyEscape():
	if activeAblity != 1:
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
		if body.is_in_group("mobs") && activeAblity != 1:
			damage()
		elif body.is_in_group("hazard"):
			damage()

func damage():
	print ("OUCH")
	activeAblity = 0
	GameUtils.Killsuck = true
	mouthFullAir = false
	overrideX = false
	overrideY = false
	abilityAni = false
	if GameUtils.Iframes == false:
		print("IFRAMEOUCH")
		GameUtils.Iframes = true
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
		await get_tree().create_timer(0.15).timeout
		$AnimatedSprite2D.show()
	elif abilityAni == true:
		$abilitySprites.hide()
		await get_tree().create_timer(0.15).timeout
		$abilitySprites.show()



func ability(abilityScore):
	#uses the hasAbility variable
	#under the press A statement
	#$abilitySprites.visible=true
	#$AnimatedSprite2D.visible=false
	abilityAni = true
	
	
	#abilityScore 1 is Fire
	if abilityScore == 1:
		activeAblity = 1
		velocity.y = 0
		set_floor_max_angle(0.05)
		overrideX = true
		overrideY = true
		$smallHitbox.call_deferred("set", "disabled", true)
		$abilitySprites/abilityCooldown.set_wait_time(1.0)
		$abilitySprites/abilityCooldown.start()
		abilityCooldown = true
		$abilitySprites.play("fireStart")
		GameUtils.Killflame = false
		projectFollow(3)
		velocity.x = 230 * GameUtils.DIR
		await $abilitySprites.animation_finished
		$abilitySprites.play("fireLoop")
		await $abilitySprites.animation_finished
		GameUtils.Killflame = true
		$smallHitbox.call_deferred("set", "disabled", false)
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
		activeAblity = 0


	if abilityScore == 2:
		pass

func _on_ability_cooldown_timeout():
	abilityCooldown = false

func abilityStop():
	await $abilitySprites.animation_finished
	$smallHitbox.call_deferred("set", "disabled", false)
	set_floor_max_angle(1)
	activeAblity = 0
	GameUtils.Killflame = true
	abilityAni = false
	overrideX = false
	overrideY = false


