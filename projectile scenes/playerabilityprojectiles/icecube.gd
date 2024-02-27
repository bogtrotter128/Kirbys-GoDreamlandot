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
	if body == null:
		pass
	if body.is_in_group("player") && start == false:
		print("start")
		start = true
		dir = body.DIR
	if body.is_in_group("mobs") && start == true:
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()

func _on_walldetect_body_entered(body):
	if body == null:
		pass
	if body.name == "maintiles" or body.is_in_group("powblock"):
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
