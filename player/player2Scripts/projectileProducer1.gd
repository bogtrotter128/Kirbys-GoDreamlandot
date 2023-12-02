extends Marker2D

@export var airpuff : PackedScene
@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var SlideHitbox : PackedScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene

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
		pass
	elif v == 5:
		pass
		#probably sweep
	elif v == 6:
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
