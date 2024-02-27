extends CharacterBody2D

var dir = 1
var SPEED = 80
var GRAVITY = 200

@export var patrol = true
@export var copyAbilityScore = 0
@export var HP = 4
var deathpoof = preload("res://enemy scenes/deathpoof/deathsprite.tscn")
var screennotif = preload("res://enemy scenes/enemy_visible_on_screen_notifier_2d.tscn")

func _ready():
	var screennotifer = screennotif.instantiate()
	call_deferred("add_child", screennotifer)
func _process(_delta):
	if HP <= 0:
		death()

func _physics_process(_delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, GRAVITY, 7)
	if patrol == true:
		velocity.x = move_toward(velocity.x, SPEED * dir, 4)
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	move_and_slide()

func _on_wall_detect_body_entered(body):
	if body.name == "maintiles"or body.is_in_group("powblock"):
		dir = dir * -1
		$"wall detect/CollisionShape2D".call_deferred("set", "disabled", true)
		$detecttimer.start()
	if body.name == "watertiles":
		velocity /= 2
		GRAVITY = 10
		SPEED = 10
		await get_tree().create_timer(2).timeout
		death()

func _on_fall_detect_l_body_exited(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		velocity.x = 0
		dir = dir * -1

func _on_fall_detect_r_body_exited(body):
	if body.name == "maintiles"or body.is_in_group("powblock"):
		velocity.x = 0
		dir = dir * -1

func _on_detecttimer_timeout():
	$"wall detect/CollisionShape2D".call_deferred("set", "disabled", false)

func death():
	velocity.x = 0
	velocity.y = -50 
	var poof = deathpoof.instantiate()
	call_deferred("add_sibling", poof)
	poof.global_transform = global_transform
	self.queue_free()

func damage(value):
	$AnimatedSprite2D.play("hurt")
	velocity.x = SPEED * dir * -1
	velocity.y = -200
	HP -= value
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.play("default")
