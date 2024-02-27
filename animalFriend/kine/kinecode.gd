extends Node

@export var starFire : PackedScene
var suckScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene
@export var stoneAbilityBox : PackedScene
@export var cutterAbilityBox : PackedScene
@export var parasolAbilityBox : PackedScene
@export var broomAbilityBox : PackedScene
func _ready():
	if $"..".is_in_group("player1"):
		suckScene = load("res://projectile scenes/swallow_shape.tscn")
	if $"..".is_in_group("player2"):
		suckScene = load("res://projectile scenes/tongue_shape.tscn")

func _input(_event):
	if Input.is_action_just_released($"..".RIGHT) or Input.is_action_just_released($"..".LEFT):
		$"../runCooloff".start()
		if Input.is_action_just_released($"..".RIGHT):
			$"..".runCheckR = true
			$"../doubletap".start()
		elif Input.is_action_just_released($"..".LEFT):
			$"..".runCheckL = true
			$"../doubletap".start()
	elif $"..".runCheckR == true or $"..".runcont == true:
		if Input.is_action_pressed($"..".RIGHT):
			$"..".run = true
	elif $"..".runCheckL == true or $"..".runcont == true:
		if Input.is_action_pressed($"..".LEFT):
			$"..".run = true
	#cancel underwter inhaling/bubble
	if Input.is_action_just_released($"..".A) && bubblestart == false:
		$"../abilityCooldown".set_wait_time(0.43)
		$"../abilityCooldown".start()
		await get_tree().create_timer(0.43).timeout
		bubblestart = true
		$"..".inhaleStop()

func _physics_process(_delta):
	var direction = Input.get_axis($"..".LEFT, $"..".RIGHT)
	if direction && $"..".is_on_floor() && $"..".crouch == false:
		$"..".velocity.y = -50
		$"..".is_jumping = false
	
func jump():
	if $"..".is_jumping == false:
		$"..".jump_timer = 0.0
		$"..".is_jumping = true
		$"..".apply_jump_force($"..".jump_power_initial)
		$"..".jump_power = $"..".jump_power_initial

func multijump():
	pass

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
	$"..".canJump = true
	$"..".overrideX = false
	$"..".overrideY = false
	$"../normalhitbox".call_deferred("set", "disabled", false)
	$"../abilityCooldown".set_wait_time(0.07)
	$"../abilityCooldown".start()
