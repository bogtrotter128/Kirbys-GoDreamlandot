extends CharacterBody2D

var dir = 1
@export var SPEED = 150
@export var SCALE = 1.0
@export var axisX = false
@export var axisY = true
@onready var spriteani = $Sprite2D/AnimationPlayer
var screennotif = preload("res://enemy scenes/enemy_visible_on_screen_notifier_2d.tscn")
var canani = false
func _ready():
	$".".scale = Vector2(SCALE,SCALE)
	var screennotifer = screennotif.instantiate()
	call_deferred("add_child", screennotifer)

func _physics_process(_delta):
	if axisX == true:
		velocity.x = move_toward(velocity.x, SPEED * dir, 2)
	if axisY == true:
		velocity.y = move_toward(velocity.y, SPEED * dir, 2)
	if not is_on_floor() && not is_on_ceiling():
		canani = true
	animations()
	move_and_slide()

func _on_timer_timeout():
	dir *= -1

func animations():
	if is_on_ceiling() && canani == true:
		canani = false
		spriteani.play("hitceiling")
		idleanimation()
	if is_on_floor()  && canani == true:
		canani = false
		spriteani.play("hitfloor")
		idleanimation()
func idleanimation():
	await spriteani.animation_finished
	spriteani.play("idle")
