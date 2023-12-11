extends Marker2D

@export var airpuff : PackedScene
@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var SlideHitbox : PackedScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene
@export var stoneAbilityBox : PackedScene
@export var dustspawn : PackedScene
@export var dustspawn2 : PackedScene

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
		
	elif v == 4: # ice
		projectS = iceAbilityBox.instantiate()
	elif v == 5: # rock's projectiles
		projectS = dustspawn.instantiate()
	elif v == 6:
		projectS = dustspawn2.instantiate()
		#probably sweep
	elif v == 10:
		projectS = dropabilitystar.instantiate()
	owner.add_sibling(projectS)
	projectS.transform = $".".global_transform

#summons hitboxes that follow the player
#missing the owner.add_child() and the $pp.global_transform
func projectFollow(v):
	var projectF
	# 1 is the inhale ability project
	# uses killsuck to queue_free
	if v == 1:
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
	if v == 5:
		projectF = stoneAbilityBox.instantiate()
	
	add_sibling(projectF)
	projectF.transform = $".".transform

func inhale():
	$"..".canInhale = false
	$"..".overrideX = true
	$"..".canJump = false
	$"..".velocity.x = 0
	$"..".inhaling = true
	GameUtils.KillsuckP2 = true
	GameUtils.KillsuckP2 = false
	projectFollow(1)

func inhaleStop():
	GameUtils.KillsuckP2 = true
	$"..".canJump = true
	$"..".canInhale = true
	$"..".inhaling = false
	$"..".overrideX = false
	$"../AbilitySprites/abilityCooldown".set_wait_time(0.2)
	$"../AbilitySprites/abilityCooldown".start()

func spitCascade():
	$"..".spit = true
	$"../AbilitySprites/abilityCooldown".set_wait_time(0.5)
	$"../AbilitySprites/abilityCooldown".start()
	#makes sure you cant multi jump after spitting out air
	if $"..".mouthFullAir == true:
		$"..".jumpCount = GameUtils.JUMPMAX
	GameUtils.mouthValueP2 = 1
	$"..".overrideX = true
	$"..".abilityCooldown = true
	$"..".mouthFull = false
	$"..".mouthFullAir = false
	$"..".velocity.x = 0
	$"..".flight = false
	await get_tree().create_timer(0.3).timeout
	$"..".spit = false
	$"..".overrideX = false
	$"..".abilityCooldown = false
	$"..".canInhale = true
	$"..".canJump = true

func slide():
	if $"..".abilityCooldown == false:
		GameUtils.KillsuckP2 = false
		$"..".slide = true
		$"..".crouch = false
		$"..".velocity.x = GameUtils.DIRP2 * 190
		$"..".overrideX = false
		projectFollow(2)
		await get_tree().create_timer(0.3).timeout
		GameUtils.KillsuckP2 = true
		$"..".velocity.x = GameUtils.DIRP2 * 190
		$"..".overrideX = false
		$"..".slide = false
		$"..".abilityCooldown = true
		$"../AbilitySprites/abilityCooldown".set_wait_time(0.2)
		$"../AbilitySprites/abilityCooldown".start()
		$"..".velocity.x = 0
		$"..".docrouch()
		if not Input.is_action_pressed("down"):
			$"..".uncrouch()
##########################################
var firestart = false
var firescore = 30


func ability(abilityScore):
	GameUtils.KillAbilityP2 = false
	if abilityScore == 1:
		fire()
	if abilityScore == 2:
		shock()
	if abilityScore == 3:
		ice()
	if abilityScore == 4:
		stone()
	if abilityScore == 5:
		spike()
	if abilityScore == 6:
		pass #cutter
	if abilityScore == 7:
		pass # parasol
	if abilityScore == 8:
		pass #broom



func abilityStop():
	GameUtils.KillAbilityP2 = true
	$"..".set_floor_max_angle(1)
	$"..".activeAbility = 0
	$"..".velocity.x = 0
	$"..".slide = false
	$"..".canJump = true
	$"..".jumpCount = 0
	$"..".overrideX = false
	$"..".overrideY = false
	stoneboxcheck = false
	$".".position.x = 8
	$".".position.y = 2
	$"../smallhitbox".position.y = 8
	$"../normalhitbox".call_deferred("set", "disabled", false)
	$"../AbilitySprites/firewallDetect".firedectOff()
	$"../AbilitySprites/iceabilityCooldown".stop()
	$"../AbilitySprites/firecooldown".start()
	$"../AbilitySprites/abilityCooldown".set_wait_time(0.07)
	$"../AbilitySprites/abilityCooldown".start()

var stoneboxcheck = false
var stonefall = false
func _process(_delta):
	
	GameUtils.posXP2 = global_position.x
	GameUtils.posYP2 = global_position.y

	#updates the fire ability's firescore
	if $"..".activeAbility == 1:
		$"..".velocity.y = 0
		if firescore >= 21:
			# strong fire
			fire3()
		elif firescore > 10 && firescore < 21:
			# mid fire
			fire2()
		elif firescore <= 10:
			# small fire
			fire1()

	#stone hitbox functions
	if $"..".activeAbility == 4:
		if stoneboxcheck == false && not $"..".is_on_floor() or stoneboxcheck == false && $"..".is_on_wall() && not $"..".is_on_floor():
			$"..".run = false
			stoneboxcheck = true
			projectFollow(5)
		elif $"..".is_on_floor() && $"..".velocity.x == 0:
			stoneboxcheck = false
			GameUtils.KillAbilityP2 = true
	#parameters for when to summon aoe effect of stone ability
		if not $"..".is_on_wall() && $"..".falling == true:
			stonefall = true

func _input(_event):
	if Input.is_action_just_pressed("left") && $"..".activeAbility == 4:
		$"..".slide = true
		$"..".velocity.x -= 40
		await get_tree().create_timer(0.1).timeout
		$"..".velocity.x = 0
		$"..".slide = false
	if Input.is_action_just_pressed("right") && $"..".activeAbility == 4:
		$"..".slide = true
		$"..".velocity.x += 40
		await get_tree().create_timer(0.1).timeout
		$"..".velocity.x = 0
		$"..".slide = false

func fire():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 1
		$"..".abilitycanstop = false
		#these make sure you cant jump or do any weird y movements during the ability
		$"..".slide = true
		$"..".is_jumping = true
		$"..".jump_timer = $"..".jump_time_max
		#
		$"../AbilitySprites/firecooldown".start()
		$"../AbilitySprites/abilityCooldown".start()
		$"..".set_floor_max_angle(0)
		$"../normalhitbox".call_deferred("set", "disabled", true)
		$"../smallhitbox".position.y = 2
		firestart = true
		projectFollow(3)
		$"..".overrideX = true
		$"..".overrideY = true
		$"..".velocity.y = 0
		$"..".run = false
		await get_tree().create_timer(0.2).timeout
		$"../AbilitySprites/firewallDetect".firedectOn()
		firestart = false

func fire3():
	print("fire3")
	$"..".velocity.x = (200) * GameUtils.DIRP2
	await get_tree().create_timer(0.2).timeout
	if firescore >= 21:
		firescore = 20
func fire2():
	print("fire2")
	$"..".activeAbility = 1
	$"..".velocity.x = (180) * GameUtils.DIRP2
	await get_tree().create_timer(0.2).timeout
	if firescore > 10 && firescore < 21:
		firescore = 10
func fire1():
	print("fire1")
	$"..".activeAbility = 1
	$"..".velocity.x = (140) * GameUtils.DIRP2
	await get_tree().create_timer(0.3).timeout
	$"..".abilitycanstop = true
	abilityStop()

var shockstart = false
func shock():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 2
		shockstart = true
		$"..".abilitycanstop = false
		await get_tree().create_timer(0.4).timeout
		GameUtils.KillAbilityP2 = false
		if not Input.is_action_pressed("a"): #if the button isnt held, stops ability
			GameUtils.KillAbilityP2 = false
			shockstart = false
			abilityStop()
		#abilty loop starts
		projectFollow(4)
		$"..".abilitycanstop = true
		shockstart = false

var iceabilityready = false
var icestart = false
func ice():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 3
		iceabilityready = false
		icestart = true
		$".".position.y = 7
		$"../AbilitySprites/iceabilityCooldown".start()
		await get_tree().create_timer(0.2).timeout
		icestart = false
		$"..".abilitycanstop = true
	if iceabilityready == true:
		projectShoot(4)
		iceabilityready = false
var rocktrue = true
func stone():
	if Input.is_action_just_pressed("a"):
		if rocktrue == true:
			position.x = 0
			position.y = 7
			rotation = 0
			$"..".overrideX = true
			$"..".jumpCount = $"..".jumpMax
			$"..".velocity.y = -10
			$"..".abilitycanstop = false
			$"..".activeAbility = 4
			$"..".set_floor_max_angle(0.0)
			rocktrue = false
		elif rocktrue == false:
			await get_tree().create_timer(0.3).timeout
			$"..".abilitycanstop = true
			abilityStop()
			$"..".apply_jump_force(-100)
			$"..".abilityCooldown = true
			$"../AbilitySprites/abilityCooldown".start()
			rocktrue = true

var spikestart = false
func spike():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 5
		spikestart = true
		$"..".abilitycanstop = false
		await get_tree().create_timer(0.3).timeout
		GameUtils.KillAbilityP2 = false
		if not Input.is_action_pressed("a"): #if the button isnt held, stops ability
			spikestart = false
			abilityStop()
		#abilty loop starts
		projectFollow(4)
		$"..".abilitycanstop = true
		spikestart = false







