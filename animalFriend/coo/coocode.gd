extends Node
var GRAVITY = 90

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
func _ready():
	if $"..".is_in_group("player1"):
		suckScene = load("res://projectile scenes/swallow_shape.tscn")
	if $"..".is_in_group("player2"):
		suckScene = load("res://projectile scenes/tongue_shape.tscn")

func _input(_event):
	if Input.is_action_just_pressed($"..".DOWN):
		GRAVITY = 200
	if Input.is_action_just_released($"..".DOWN):
		GRAVITY = 90
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

func _physics_process(_delta):
	var direction = Input.get_axis($"..".LEFT, $"..".RIGHT)
	if direction && $"..".is_on_floor() && $"..".crouch == false:
		$"..".velocity.y = -50
	if bubblego == true && bubblestart == false:
		bubblego = false
		$"../projectileProducer".projectShoot(bubble)
	if $"..".is_on_floor():
		jumpCount = 0
	if Input.is_action_pressed($"..".JUMP) && $"..".swim == false && $"..".crouch == false:
		fly()
func jump():
	pass
func multijump():
	pass
	
var jumpCount = 0
func fly():
	await get_tree().create_timer(0.1).timeout
	if jumpCount < 70:
		jumpCount += 1
		$"..".velocity.y = -120 + jumpCount
	else:
		$"..".velocity.y += -3

func fallphysics():
	$"..".falling = true
	$"..".canjump = false
	$"..".is_jumping = true
	$"..".velocity.y = move_toward($"..".velocity.y, GRAVITY, 5)

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
	$"..".velocity.x = 0
	bubblestart = true
	$"..".canjump = true
	$"..".overrideX = false
	$"..".overrideY = false
	$"../normalhitbox".call_deferred("set", "disabled", false)
	$"../abilityCooldown".set_wait_time(0.07)
	$"../abilityCooldown".start()


func _on_coyote_timer_timeout():
	pass # Replace with function body.
