extends CharacterBody2D

@export var SPEED = 200
var start = false
var dir = 1

func _ready():
	$walldetect/CollisionShape2D.call_deferred("set", "disabled", true)

func _physics_process(_delta):
	if start == true:
		velocity.x = SPEED * dir
		$walldetect/CollisionShape2D.call_deferred("set", "disabled", false)
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") && start == false:
		print("start")
		start = true
		if body.global_position.x < self.global_position.x:
			dir = 1
		elif body.global_position.x > self.global_position.x:
			dir = -1
	if body.is_in_group("mobs") && start == true:
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()

func _on_walldetect_body_entered(body):
	if body.name == "maintiles":
		await get_tree().create_timer(0.4).timeout
		self.queue_free()
