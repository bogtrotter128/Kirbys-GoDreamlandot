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
@export var cutterAbilityBox : PackedScene

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
		projectS = dustspawn.instantiate()
		projectS.speed = -40
	elif v == 7:
		projectS = cutterAbilityBox.instantiate()
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
		projectF.add_to_group("player1")
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

func _input(_event):
		#handles spit inpit
	if Input.is_action_just_pressed("a") && $"..".mouthFull == true or Input.is_action_just_pressed("a") && $"..".mouthFullAir == true:
		projectShoot(GameUtils.mouthValue)
		spitCascade()

func inhale():
	$"..".canInhale = false
	$"..".overrideX = true
	$"..".canJump = false
	$"..".velocity.x = 0
	$"..".inhaling = true
	GameUtils.Killsuck = true
	GameUtils.Killsuck = false
	projectFollow(1)

func inhaleStop():
	GameUtils.Killsuck = true
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
	GameUtils.mouthValue = 1
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
		GameUtils.Killsuck = false
		$"..".slide = true
		$"..".crouch = false
		$"..".velocity.x = GameUtils.DIR * 190
		$"..".overrideX = false
		projectFollow(2)
		await get_tree().create_timer(0.3).timeout
		GameUtils.Killsuck = true
		$"..".velocity.x = GameUtils.DIR * 190
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
	GameUtils.KillAbility = false
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
		cutter()
	if abilityScore == 7:
		parasol()
	if abilityScore == 8:
		broom()



func abilityStop():
	GameUtils.KillAbility = true
	$"..".set_floor_max_angle(1)
	$"..".activeAbility = 0
	$"..".velocity.x = 0
	$"..".slide = false
	$"..".canJump = true
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
			GameUtils.KillAbility = true
	#parameters for when to summon aoe effect of stone ability
		if not $"..".is_on_wall() && $"..".falling == true:
			stonefall = true

func fire():
	if $"..".activeAbility == 0 && Input.is_action_just_pressed("a"):
		$"..".abilitycanstop = false
		$"..".activeAbility = 1
		#these make sure you cant jump or do any weird y movements during the ability
		$"..".slide = true
		$"..".is_jumping = true
		$"..".jump_timer = $"..".jump_time_max
		#
		$"../AbilitySprites/firecooldown".start()
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
	$"..".velocity.x = (200) * GameUtils.DIR
	await get_tree().create_timer(0.2).timeout
	if firescore >= 21:
		firescore = 20
func fire2():
	$"..".activeAbility = 1
	$"..".velocity.x = (180) * GameUtils.DIR
	await get_tree().create_timer(0.2).timeout
	if firescore > 10 && firescore < 21:
		firescore = 10
func fire1():
	$"..".activeAbility = 1
	$"..".velocity.x = (140) * GameUtils.DIR
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
		GameUtils.KillAbility = false
		if not Input.is_action_pressed("a"): #if the button isnt held, stops ability
			GameUtils.KillAbility = false
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
		$".".position.y = 5
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
			$"..".iframes = true
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
			$"..".iframes = false
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
		GameUtils.KillAbility = false
		if not Input.is_action_pressed("a"): #if the button isnt held, stops ability
			spikestart = false
			abilityStop()
		#abilty loop starts
		projectFollow(4)
		$"..".abilitycanstop = true
		spikestart = false

var cutterstart = false
var upalt = false
func cutter():
	if Input.is_action_pressed("up"):
		upalt = true
	if $"..".activeAbility == 0:
		$"..".activeAbility = 6
		$"..".abilitycanstop = false
		cutterstart = true
		projectShoot(7)
		await $"../AbilitySprites".animation_finished
		cutterstart = false
		$"..".activeAbility = 0
		$"..".abilitycanstop = true
		abilityStop()
		upalt = false

func parasol():
	pass

func broom():
	pass

