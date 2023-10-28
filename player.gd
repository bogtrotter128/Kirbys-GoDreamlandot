extends CharacterBody2D

#https://www.youtube.com/watch?v=tAW-7deSZrw&list=PLL0CQjrcN8D21x5SwzCb10NQ5CYJnlozj&index=1

const SPEED = 80.0
const JUMP_VELOCITY = -340.0
const JUMP_VELOCITY_STEP = 10
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var airPuff : PackedScene
@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var slideHitbox : PackedScene
@export var fireAbilityBox : PackedScene

@onready var HPHUD = $CanvasLayer/HUD/HPbar
@onready var Starbar = $CanvasLayer/HUD/Starbar
@onready var enemyBar = $CanvasLayer/HUD/enemybar
@onready var abilitycard = $CanvasLayer/HUD/abilitycard

@onready var sucker = suckScene.instantiate()
###########################################################
var jumpMax = 3
var jumpCount = 0
var jump_power_initial = -150
var jump_power = 0
var jump_time_max = 0.16
var jump_timer = 0.0
var is_jumping = false
###########################################################
var abilityCooldown = false
var overrideY = false
var overrideX = false
var crouch = false
var canInhale = true
var mouthFull = false
var mouthFullAir = false
var crouchOverride = false
var collideCheck = false
############################################################
var activeAblity = 0
var frameFlashAni = false
var abilityAni = false
var hasAbility = false
var spit = false
var flight = false
var falling = false
var runCheckR = false
var runCheckL = false
var runcont = false
var run = false
var slide = false

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

func _input(event):
	if event.as_text() in uiInputs:
		GameUtils.ABILITY = hashTable[event.as_text()]
		abilitycard.update_ability_card(GameUtils.ABILITY)
	if event.is_action_released("b") && is_jumping:
		jump_timer = jump_time_max
	
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

func _ready():
	$abilitySprites.visible=false
	


func _process(_delta):
	
	#FIX this enemybar breaks a lot of the time, need to fix
	enemyBar.update_enemy_bar(GameUtils.enemyHP)
	
	#sets kirby's max health at 10
	#probably nove this somewhere better?
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
	if GameUtils.mouthValue > 1:
		mouthFull = true
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

	if collideCheck == true:
		bodyEscape()


func _physics_process(delta):
	# Please please please stop


	if activeAblity != 1:
		#stuff that happens when kirby lands back on the ground
		if is_on_floor():
			jumpCount = 0
			flight = false
			jump_timer = 0.0
			is_jumping = false
			#custom landing stuff
			if falling == true:
				if mouthFull == false:
					$AnimatedSprite2D.play("crouch")
				falling = false
				overrideX = true
				if mouthFull == true:
					$AnimatedSprite2D.play("fat land")
					await get_tree().create_timer(0.15).timeout
					overrideX = false
				else:
					overrideX = false
		#makes kirby spit out the puff of air after flying
			if mouthFullAir == true:
				shootpuff()
				spit = true
				canInhale = false
				overrideX = true
				$AnimatedSprite2D.play("open")
				mouthFull = false
				mouthFullAir = false
				velocity.x = 0
				await get_tree().create_timer(0.2).timeout
				canInhale = true
				overrideX = false
				flight = false
				falling = false
				spit = false



		# Add the gravity, 
		if not is_on_floor() && overrideY == false:
			jump_timer += delta
			velocity.y += gravity * delta
			velocity.y = velocity.y * 0.97
			if slide == false:
				crouch = false
				crouchOverride = false
		#handles jump animations
			if flight == false and falling == false:
				if mouthFull == false and $AnimatedSprite2D.animation != "hurt":
					$AnimatedSprite2D.play("jump")
				elif mouthFull == true and $AnimatedSprite2D.animation != "fat hurt":
					$AnimatedSprite2D.play("fat jump")
				falling = true
				overrideX = false
		#handles multi jumps
			if Input.is_action_just_pressed("b") and jumpCount < jumpMax:
				if mouthFull == false and $AnimatedSprite2D.animation != "hurt":
					mouthFullAir = true
					flight = true
					velocity.y = JUMP_VELOCITY + -100 + (40 * jumpCount)
					jumpCount += 1
		if flight == true:
			if Input.is_action_just_pressed("b"):
				$AnimatedSprite2D.play("flap")
			velocity.y = velocity.y * 0.86
			velocity.x = velocity.x * 0.75


	#########################################################################################
		# Handle Jump.
		#cant jump while holding down
		if not Input.is_action_pressed("down"):
			if Input.is_action_pressed("b") && crouch == false && crouchOverride == false:
				if overrideY == false and is_jumping == false:
					jump_timer = 0.0
					is_jumping = true
					apply_jump_force(jump_power_initial)
					jump_power = jump_power_initial
				elif Input.is_action_pressed("b") && is_jumping && jump_timer < jump_time_max:
					if overrideY == false:
						jump_power -= JUMP_VELOCITY_STEP
						apply_jump_force(jump_power)
			#the jump animation is handled at the not is_on_floor() function

		#handles crouch
		if is_on_floor() and Input.is_action_pressed("down") and $AnimatedSprite2D.animation != "open":
			crouch = true
			overrideX = true
			swallow()
			
			if slide == false and is_on_floor():
				$AnimatedSprite2D.play("crouch")
				velocity.x = 0
		if crouch == true:
			$normalhitbox.call_deferred("set", "disabled", true)
			$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", true)


	#releases the crouch but only if crouchOverride isnt active
		if crouch == true and not Input.is_action_pressed("down"):
			if slide == false:
				if crouchOverride == false:
					await get_tree().create_timer(0.1).timeout
					overrideX = false
					$normalhitbox.call_deferred("set", "disabled", false)
					$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", false)
					crouch = false
		###########################################################################################################################
		#if crouch == false && crouchOverride == false:
			#this makes it so the uncrouch only happens if you arent using an ability
		#	if activeAblity < 1:
		#		$normalhitbox.call_deferred("set", "disabled", false)
		#		$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", false)


		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
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
		if overrideX == false:
			if direction:
				velocity.x = direction * SPEED
				if run == true:
					velocity.x = velocity.x * 1.64
				if mouthFull == true:
					velocity.x = velocity.x * 0.75
				
				if is_on_floor():
					if $AnimatedSprite2D.animation != "jump" or $AnimatedSprite2D.animation == "jump":
						if run == false and mouthFull == false:
							$AnimatedSprite2D.play("walk")
						elif run == true and mouthFull == false:
							$AnimatedSprite2D.play("run")
						elif mouthFull == true:
							$AnimatedSprite2D.play("fat run")

			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if velocity.y == 0 and spit == false:
					if mouthFull == false:
						$AnimatedSprite2D.play("idle")
					elif mouthFull == true:
						$AnimatedSprite2D.play("fat idle")



	#discription: discerning double tapping done with double diretection determining
		if falling == false:
			if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
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




	move_and_slide()# Huh?




#action inputs ____ A _____ B _____ C ____ A _____ B _____ C ____ A _____ B _____ C
#||  A  __  B   __  C  || 
#|| MB1 __SPACE __ MB2 || 
#||  Z  __  X   __  C  || 
#||  J  __  K   __  L  ||


	#handles the slide (down + B)
	if crouch == true && slide == false && is_on_floor():
		if Input.is_action_just_pressed("b") && abilityCooldown == false:
			$AnimatedSprite2D.play("slide")
			slide = true
			GameUtils.Killsuck = false
			slideKick()
			velocity.x = GameUtils.DIR * 200
			await get_tree().create_timer(0.2).timeout
			velocity.x = GameUtils.DIR * 200
			GameUtils.Killsuck = true
			await get_tree().create_timer(0.1).timeout
			slide = false
			abilityCooldown = true
			$abilitySprites/abilityCooldown.set_wait_time(0.2)
			$abilitySprites/abilityCooldown.start()
			if slide == false and is_on_floor():
				velocity.x = 0
				$AnimatedSprite2D.play("crouch")
				crouch = true
				if Input.is_action_just_released("b"):
					crouch = false
			
	#handles inhaling A
	if mouthFull == false && spit == false && $AnimatedSprite2D.animation != "hurt" && crouch == false:
		# There is no other elig statement after this just put the if statement in the outer if statement bruh
		if hasAbility == false:
			if Input.is_action_pressed("a"):
				inhale()
				velocity.x = 0
				canInhale = false
				overrideX = true
				if is_on_floor():
					overrideY = true
				$AnimatedSprite2D.play("open")
	if Input.is_action_just_released("a") && canInhale == false:
		canInhale = true
		overrideX = false
		overrideY = false
		GameUtils.Killsuck = true

	#handles abilities A  A  A    a  a  a
	if hasAbility == true && mouthFullAir == false:
		if Input.is_action_just_pressed("a") && overrideX == false && abilityCooldown == false:
			ability(GameUtils.ABILITY)
		if Input.is_action_just_released("a") or abilityCooldown == false:
			await $abilitySprites.animation_finished
			$smallHitbox.call_deferred("set", "disabled", false)
			set_floor_max_angle(1)
			activeAblity = 0
			GameUtils.Killflame = true
			abilityAni = false
			overrideX = false
			overrideY = false
######################################################################W#########
	
	
	#handles spitting A
	if mouthFull == true or mouthFullAir == true:
		canInhale = false
		#handles spitting out air puff while flying
		if Input.is_action_just_pressed("a"): #Lone if statement that could have just been put in the outer if statement
		#if kirby's mouth is full of air, it will only spit out air
			if mouthFullAir == true:
				shootpuff()
				GameUtils.mouthValue = 1
				print("puff")
				mouthFullAir = false
		#otherwise, kirby will spit whatever is in mouth
			elif mouthFull == true:
				shootStar()
#NEED TO HAVE A CONTINGENCY FOR WHEN THERE IS MORE THAN 1 STAR
				GameUtils.mouthValue = 1
				print("starshoot")
			jumpCount = 3
			#mouthValue is 1 by default, so that it's 1 more than airpuff
			GameUtils.mouthValue = 1
			spit = true
			overrideX = true
			$AnimatedSprite2D.play("open")
			velocity.y = 0
			await get_tree().create_timer(0.1).timeout
			overrideX = false
			flight = false
			falling = false
			mouthFullAir = false
	if Input.is_action_just_released("a"):
		spit = false
		mouthFull = false
		canInhale = true
		if $AnimatedSprite2D.visible == false:
			$AnimatedSprite2D.visible=true
			$abilitySprites.visible=false




	if Input.is_action_just_pressed("c"):
		if mouthFull == true: # Lone if statment that could have been put in the outer
			swallow()
			if is_on_floor() and $AnimatedSprite2D.animation != "open":
				crouch = true
				overrideX = true
				$AnimatedSprite2D.play("crouch")
				velocity.x = 0
			if crouch == true: 
				# ???????????????????????????????????????? This will always run if the previous
				# If statement is true
				$normalhitbox.call_deferred("set", "disabled", true)
				$bodyCollideDetect/CollisionShape2D.call_deferred("set", "disabled", true)

func apply_jump_force(power):
	velocity.y = power


func _on_doubletap_timeout():
	runCheckR = false
	runCheckL = false

func _on_run_cooloff_timeout():
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		run = false


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
	if activeAblity < 1:
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


func slideKick():
	var kickbox
	kickbox = slideHitbox.instantiate()
	add_child(kickbox)
	kickbox.transform = $projectileProducer.transform

func summonFireAbilityBox():
	var firebox
	firebox = fireAbilityBox.instantiate()
	add_child(firebox)
	firebox.transform = $projectileProducer.transform

func shootpuff():
	var puff
	puff = airPuff.instantiate()
	owner.add_child(puff)
	puff.transform = $projectileProducer.global_transform
	
func shootStar():
	var star = starFire.instantiate()
	owner.add_child(star)
	star.transform = $projectileProducer.global_transform


func inhale():
	if canInhale == true and mouthFull == false:
		GameUtils.Killsuck = false
		canInhale = false
		sucker = suckScene.instantiate()
		#this one is missing the owner.add_child() and the $pp.global_transform
		#because we want it to follow kirby
		add_child(sucker)
		sucker.transform = $projectileProducer.transform

func swallow():
	if hasAbility == false:
		spit = false
		mouthFull = false
		mouthFullAir = false
		canInhale = true
		GameUtils.ABILITY = GameUtils.HELDABILITY
		abilitycard.update_ability_card(GameUtils.ABILITY)
		GameUtils.mouthValue = 1






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
		summonFireAbilityBox()
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
		spit = false
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






