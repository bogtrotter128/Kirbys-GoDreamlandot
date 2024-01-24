extends Node

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

func jump():
	if $"..".is_jumping == false:
		$"..".jump_timer = 0.0
		$"..".is_jumping = true
		$"..".apply_jump_force($"..".jump_power_initial)
		$"..".jump_power = $"..".jump_power_initial

func multijump():
	pass

func inahle():
	pass

func fallphysics():
	$"..".falling = true
	#no mid-air jump
	$"..".canJump = false
	#but can still multijump\/
	$"..".is_jumping = true
	if $"..".flight == false:
		$"..".velocity.y = move_toward($"..".velocity.y, 200, 7)
	elif $"..".flight == true:
		$"..".velocity.y = move_toward($"..".velocity.y, 40, 7)

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
		projectS.global_position.x += 8
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
		projectF.add_to_group("player2")
		projectF.spritevisible=false
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
	if Input.is_action_just_pressed($"..".A) && $"..".mouthFull == true or Input.is_action_just_pressed($"..".A) && $"..".mouthFullAir == true:
		projectShoot(GameUtils.mouthValueP2)
		spitCascade()

func killsuck():
	if $"..".is_in_group("player1"):
		GameUtils.Killsuck = true
		GameUtils.Killsuck = false
		GameUtils.KillAbility = true
	elif $"..".is_in_group("player2"):
		GameUtils.KillsuckP2 = true
		GameUtils.KillsuckP2 = false
		GameUtils.KillAbilityP2 = true

func mouthval(val):
	if $"..".is_in_group("player1"):
		GameUtils.mouthValue = val
	elif $"..".is_in_group("player2"):
		GameUtils.mouthValueP2 = val

func inhale():
	$"..".canInhale = false
	$"..".overrideX = true
	$"..".canJump = false
	$"..".velocity.x = 0
	$"..".inhaling = true
	killsuck()
	projectFollow(1)

func inhaleStop():
	killsuck()
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
	mouthval(1)
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

##########################################

func fire():
	pass
func shock():
	pass

func ice():
	pass

func stone():
	pass

func spike():
	pass

func cutter():
	pass

func parasol():
	pass

func broom():
	pass

func abilityStop():
	killsuck()
	$"..".set_floor_max_angle(1)
	$"..".activeAbility = 0
	$"..".velocity.x = 0
	$"..".slide = false
	$"..".canJump = true
	$"..".overrideX = false
	$"..".overrideY = false
#	stoneboxcheck = false
	$".".position.x = 8
	$".".position.y = 2
	$"../smallhitbox".position.y = 8
	$"../normalhitbox".call_deferred("set", "disabled", false)
	$"../AbilitySprites/firewallDetect".firedectOff()
	$"../AbilitySprites/iceabilityCooldown".stop()
	$"../AbilitySprites/firecooldown".start()
	$"../AbilitySprites/abilityCooldown".set_wait_time(0.07)
	$"../AbilitySprites/abilityCooldown".start()
