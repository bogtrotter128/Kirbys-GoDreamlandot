extends Marker2D

@export var airpuff : PackedScene
@export var bubble : PackedScene
@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var SlideHitbox : PackedScene
@export var dropabilitystar : PackedScene

var fireAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/fireabilitybox.tscn")
var shockAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/shockabilitybox.tscn")
var iceAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/iceabilityhitbox.tscn")
var stoneAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/stonehitbox.tscn")
var cutterAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/cutterabilityprojectile.tscn")
var parasolAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/parasolhitbox.tscn")
var broomAbilityBox = preload("res://projectile scenes/playerabilityprojectiles/broom_abilitybox.tscn")
#var bombAbilityBox = preload("")

var group = ""
var mouthval = 0
func _ready():
	if $"..".is_in_group("player1"):
		group = "player1"
		mouthval = GameUtils.mouthValue
	if $"..".is_in_group("player2"):
		group = "player2"
		mouthval = GameUtils.mouthValueP2

func _input(_event):
	if $"..".swim == true && $"..".overrideX == false && $"..".hasAbility == false && not $"..".is_on_floor():
		if Input.is_action_pressed($"..".UP) or Input.is_action_pressed($"..".JUMP):
			rotation_degrees = 270
		if Input.is_action_pressed($"..".DOWN):
			rotation_degrees = 90
		if Input.is_action_pressed($"..".LEFT):
			rotation_degrees = 180
		if Input.is_action_pressed($"..".RIGHT):
			rotation_degrees = 0
#handles spit inpit
	if Input.is_action_just_pressed($"..".A) && $"..".mouthFull == true or Input.is_action_just_pressed($"..".A) && $"..".mouthFullAir == true:
		if mouthval == 1:
			projectShoot(airpuff)
			$"..".jumpCount = GameUtils.JUMPMAX
		if mouthval == 2:
			projectShoot(starFire)
		spitCascade()

func _process(_delta):
	if group == "player1":
		mouthval = GameUtils.mouthValue
	if group == "player2":
		mouthval = GameUtils.mouthValueP2

func _physics_process(_delta):
#this stops kirby from moving while an ability is active and on the floor
	if $"..".activeAbility > 0 && $"..".is_on_floor() or bubblestart == false or $"..".activeAbility > 0 && $"..".swim == true:
		$"..".overrideX = true
		$"..".canJump = false
		$"..".velocity.x = move_toward($"..".velocity.x, 0, 5)
		if $"..".activeAbility != 4:
			$"..".velocity.y = move_toward($"..".velocity.y, 0, 5)
	
	if $"..".DIR == 1 && $"..".swim == false or $"..".DIR == 1 && $"..".hasAbility == true or $"..".DIR == 1 && $"..".is_on_floor():
		rotation_degrees = 0
	if $"..".DIR == -1 && $"..".swim == false or $"..".DIR == -1 && $"..".hasAbility == true or $"..".DIR == -1 && $"..".is_on_floor():
		rotation_degrees = 180
	#bullbe blower
	if bubbleblowready == true && bubblestart == false:
		bubbleblowready = false
		projectShoot(bubble)

func projectShoot(item):
	var projectS
	projectS = item.instantiate()
	projectS.add_to_group(group)
	owner.call_deferred("add_sibling", projectS)
	projectS.transform = $".".global_transform

#summons hitboxes that follow the player
#missing the owner.add_child() and the $pp.global_transform
func projectFollow(item):
	var projectF
	projectF = item.instantiate()
	projectF.add_to_group(group)
	call_deferred("add_sibling", projectF)
	projectF.transform = $".".transform

func inhale():
	$"..".canInhale = false
	$"..".overrideX = true
	$"..".canJump = false
	$"..".velocity.x = 0
	$"..".inhaling = true
	projectFollow(suckScene)

func inhaleStop():
	$"..".canJump = true
	$"..".canInhale = true
	$"..".inhaling = false
	$"..".overrideX = false
	$"..".abilityCooldown = true
	$"../AbilitySprites/abilityCooldown".set_wait_time(0.1)
	$"../AbilitySprites/abilityCooldown".start()

func spitCascade():
	$"..".spit = true
	$"../AbilitySprites/abilityCooldown".set_wait_time(0.5)
	$"../AbilitySprites/abilityCooldown".start()
	#makes sure you cant multi jump after spitting out air
	if group == "player1":
		GameUtils.mouthValue = 1
	if group == "player2":
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
	if $"..".abilityCooldown == false && $"..".swim == false:
		$"..".slide = true
		$"..".crouch = false
		$"..".velocity.x = $"..".DIR * 190
		$"..".overrideX = false
		projectFollow(SlideHitbox)
		await get_tree().create_timer(0.3).timeout
		$"..".velocity.x = $"..".DIR * 190
		$"..".overrideX = false
		$"..".slide = false
		$"..".abilityCooldown = true
		$"../AbilitySprites/abilityCooldown".set_wait_time(0.2)
		$"../AbilitySprites/abilityCooldown".start()
		$"..".velocity.x = 0
		$"..".uncrouch()
		if Input.is_action_pressed($"..".DOWN):
			$"..".docrouch()
var bubblestart = true
var bubbleblowready = false
func bubbleblow():
	if bubblestart == true:
		bubblestart = false
		bubbleblowready = false
		$"../AbilitySprites/bubble timer".start()
func _on_bubble_timer_timeout():
	bubbleblowready = true

##########################################
func ability(abilityScore):
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
	if $"..".abilitycanstop == true:
		$"..".set_floor_max_angle(1)
		$"..".activeAbility = 0
		$"..".velocity.x = 0
		$"..".parasolup = true
		$"..".slide = false
		$"..".canJump = true
		bubblestart = true
		$"..".overrideX = false
		$"..".overrideY = false
		$"../smallhitbox".position.y = 8
		$"../normalhitbox".call_deferred("set", "disabled", false)
		$"..".abilityCooldown = true
		$"../AbilitySprites/abilityCooldown".set_wait_time(0.07)
		$"../AbilitySprites/abilityCooldown".start()
func fire():
	if $"..".activeAbility == 0:
		projectFollow(fireAbilityBox)
		if $"..".run == true:
			$"..".abilityCooldown = true
			$"../AbilitySprites/abilityCooldown".set_wait_time(0.7)
			$"../AbilitySprites/abilityCooldown".start()

var shockstart = false
func shock():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 2
		shockstart = true
		$"..".abilitycanstop = false
		await get_tree().create_timer(0.4).timeout
		#abilty loop starts
		projectFollow(shockAbilityBox)
		$"..".abilitycanstop = true
		shockstart = false
	if not Input.is_action_pressed($"..".A): #if the button isnt held, stops ability
		shockstart = false
		abilityStop()

func ice():
	if $"..".iceabilityready == false:
		$"..".iceabilityready = true
		projectFollow(iceAbilityBox)
		print("icebox")

var rocktrue = true
func stone():
	if Input.is_action_just_pressed($"..".A):
		if rocktrue == true:
			$"..".activeAbility = 4
			$"..".iframes = true
			$"..".overrideX = true
			$"..".jumpCount = $"..".jumpMax
			$"..".velocity.y = -10
			$"..".abilitycanstop = false
			$"..".set_floor_max_angle(0.0)
			rocktrue = false
		elif rocktrue == false:
			await get_tree().create_timer(0.3).timeout
			$"..".abilitycanstop = true
			abilityStop()
			$"..".iframes = false
			$"..".abilityCooldown = true
			$"../AbilitySprites/abilityCooldown".start()
			rocktrue = true

var spikestart = false
func spike():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 5
		spikestart = true
		$"..".abilitycanstop = false
		await get_tree().create_timer(0.15).timeout
		if not Input.is_action_pressed($"..".A): #if the button isnt held, stops ability
			spikestart = false
			abilityStop()
		#abilty loop starts
		projectFollow(shockAbilityBox)
		$"..".abilitycanstop = true
		spikestart = false

var cutterstart = false #used by abilitySprites
func cutter():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 6
		$"..".abilitycanstop = false
		cutterstart = true
		projectShoot(cutterAbilityBox)
		await $"../AbilitySprites".animation_finished
		cutterstart = false
		$"..".activeAbility = 0
		$"..".abilitycanstop = true
		abilityStop()

func parasol():
	if $"..".parasolspawn == false:
		$"..".parasolspawn = true
		projectFollow(parasolAbilityBox)
	if $"..".activeAbility == 0 && $"..".crouch == false:
		$"..".activeAbility = 7
		$"..".abilitycanstop = false
		await get_tree().create_timer(0.12).timeout
		$"..".parasolup = false
		await $"../AbilitySprites".animation_finished
		$"..".parasolup = true
		$"..".abilitycanstop = true
		abilityStop()
func broom():
	if $"..".activeAbility == 0:
		$"..".activeAbility = 8
		projectFollow(broomAbilityBox)

func bomb():
	pass
