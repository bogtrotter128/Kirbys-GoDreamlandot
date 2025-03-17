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

func _physics_process(_delta):
	if $"..".is_on_floor() or $"..".swim == true:
		jumpCount = 0
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
var jumpMax = 3
func multijump():
	if jumpCount < jumpMax:
		jumpCount +=1
		$"../AnimatedSprite2D".dbjump = true
		$"..".velocity.y = -150
		$"..".jumpCooldown = true
		$"../jumpcooldown".set_wait_time(0.2)
		$"../jumpcooldown".start()

func fallphysics():
	$"..".falling = true
	$"..".canjump = false
	$"..".is_jumping = true
	$"..".velocity.y = move_toward($"..".velocity.y, 200, 7)

func inhale():
	$"..".overrideX = true
	$"..".canjump = false
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
	bubblestart = true
	$"..".velocity.x = 0
	$"..".canjump = true
	$"..".overrideX = false
	$"..".overrideY = false
	$"../normalhitbox".call_deferred("set", "disabled", false)
	$"../abilityCooldown".set_wait_time(0.07)
	$"../abilityCooldown".start()
