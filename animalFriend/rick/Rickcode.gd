extends Node

@export var starFire : PackedScene
var bubble = preload("res://projectile scenes/bubblebox.tscn")
@export var suckScene : PackedScene
@export var dropabilitystar : PackedScene

@export var fireAbilityBox : PackedScene
@export var shockAbilityBox : PackedScene
@export var iceAbilityBox : PackedScene
@export var stoneAbilityBox : PackedScene
@export var dustspawn : PackedScene
@export var cutterAbilityBox : PackedScene
@export var parasolAbilityBox : PackedScene
@export var broomAbilityBox : PackedScene

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
	if wallcling == false:
		$"..".velocity.y = move_toward($"..".velocity.y, 200, 7)
	if wallcling == true && $"..".swim == false:
		$"..".velocity.y = move_toward($"..".velocity.y, 150, 7)
func inhale():
	pass

func spitup(v):
	if v == 1:
		pass
	if v == 2:
		$"../projectileProducer".projectShoot(starFire)
	$"..".spitCascade()

var wallcling = false
var walljump = false
func _process(_delta):
	if Input.is_action_pressed($"..".LEFT) or Input.is_action_pressed($"..".RIGHT):
		wallcling = true
func _input(_event):
	if Input.is_action_just_released($"..".LEFT) or Input.is_action_just_released($"..".RIGHT):
		wallcling = false
		walljump = false
	if Input.is_action_just_pressed($"..".JUMP) && walljump == true:
		wallcling = false
		$"..".canJump = true
		$"..".is_jumping = false
		$"..".velocity.x += -45 * $"..".DIR
		jump()

func _physics_process(_delta):
	if $"..".is_on_wall_only() && wallcling == true && $"..".swim == false:
		$"..".velocity.y = 0
		walljump = true
	if not $"..".is_on_wall_only():
		wallcling = false
		walljump = false
	if bubblego == true && bubblestart == false:
		bubblego = false
		$"../projectileProducer".projectShoot(bubble)

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
