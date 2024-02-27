extends Node

@export var starFire : PackedScene
var bubble = preload("res://projectile scenes/bubblebox.tscn")
var suckScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene
@export var stoneAbilityBox : PackedScene
@export var cutterAbilityBox : PackedScene
@export var parasolAbilityBox : PackedScene
@export var broomAbilityBox : PackedScene
@export var bombAbilityBox : PackedScene

func _ready():
	if $"..".is_in_group("player1"):
		suckScene = load("res://projectile scenes/swallow_shape.tscn")
	if $"..".is_in_group("player2"):
		suckScene = load("res://projectile scenes/tongue_shape.tscn")
	$"../normalhitbox".shape.size.y = 15.0
	$"../normalhitbox".position.y += 2
	$"../smallhitbox".shape.size.y = 8.0
var flightstart = false
func _physics_process(_delta):
	if $"..".is_on_floor():
		jumpCount = 0
		$"..".flight = false
		flightstart = false
	if Input.is_action_pressed($"..".JUMP) && flightstart == true:
		fly()
	if bubblego == true && bubblestart == false:
		bubblego = false
		$"../projectileProducer".projectShoot(bubble)

func jump():
	if $"..".is_jumping == false:
		$"..".jump_timer = 0.0
		$"..".is_jumping = true
		$"..".apply_jump_force($"..".jump_power_initial)
		$"..".jump_power = $"..".jump_power_initial

var jumpCount = 0
func multijump():
	$"..".flight = true
	flightstart = true

func fly():
	await get_tree().create_timer(0.1).timeout
	if jumpCount < 90:
		jumpCount += 1
		$"..".velocity.y = -90 + jumpCount
	else:
		$"..".velocity.y += -5

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
		bubblego = false
		$"../bubbletimer".start()
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
