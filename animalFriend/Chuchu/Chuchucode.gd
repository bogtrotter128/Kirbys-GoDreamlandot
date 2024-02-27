extends Node

@export var starFire : PackedScene
@export var suckScene : PackedScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene
@export var stoneAbilityBox : PackedScene
@export var cutterAbilityBox : PackedScene
@export var parasolAbilityBox : PackedScene
@export var broomAbilityBox : PackedScene

var jumpCount = 0
var climb = false
func _input(_event):
	if Input.is_action_just_pressed($"..".UP) && climb == true or Input.is_action_just_pressed($"..".DOWN) && climb == true:
		stopclimb()
	#cancel underwter inhaling/bubble
	if Input.is_action_just_released($"..".A) && bubblestart == false:
		bubblestart = true
		$"..".inhaleStop()

func _process(_delta):
	if Input.is_action_pressed($"..".UP) && $"..".mouthFull == false:
		climb = true
func _physics_process(_delta):
	if $"..".is_on_floor() or $"..".swim == true:
		$"..".flight = false
		jumpCount = 0
	if $"..".is_on_ceiling() && climb == true:
		$"../AnimatedSprite2D".climbani = true
		$"..".overrideY = true
		$"..".velocity.y = -10
	if not $"..".is_on_ceiling() && climb == true:
		stopclimb()
func stopclimb():
	climb = false
	$"../AnimatedSprite2D".climbani = false
	$"..".overrideY = false

func jump():
	if $"..".is_jumping == false:
		$"..".jump_timer = 0.0
		$"..".is_jumping = true
		$"..".apply_jump_force($"..".jump_power_initial)
		$"..".jump_power = $"..".jump_power_initial

func multijump():
	$"..".flight = true
	if jumpCount <= 6:
		$"..".velocity.y = -150 + (25 * jumpCount)
	else:
		$"..".velocity.y = -5
	jumpCount += 1
	$"..".jumpCooldown = true
	$"../jumpcooldown".start()

func fallphysics():
	$"..".falling = true
	$"..".canJump = false
	$"..".is_jumping = true
	$"..".velocity.y = move_toward($"..".velocity.y, 200, 7)

func inhale():
	$"..".overrideX = true
	$"..".canJump = false
	$"..".velocity.x = 0

func spitup(v):
	if v == 1:
		pass
	if v == 2:
		$"../projectileProducer".projectShoot(starFire)
	$"..".spitCascade()

var bubblestart = true
var bubblego = false
func bubbleblow():
	if bubblestart == true:
		bubblestart = false
		$"..".inhale()
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
	$"..".set_floor_max_angle(1)
	$"..".activeAbility = 0
	$"..".velocity.x = 0
	bubblestart = true
	$"..".canJump = true
	$"..".overrideX = false
	$"..".overrideY = false
	$"../normalhitbox".call_deferred("set", "disabled", false)
	$"../abilityCooldown".set_wait_time(0.07)
	$"../abilityCooldown".start()
