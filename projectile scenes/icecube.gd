extends CharacterBody2D

@export var SPEED = 200
var start = false
var dir = 1

func _physics_process(_delta):
	if start == true:
		velocity.x = SPEED * dir
	if GameUtils.DIR == -1:
		$Sprite2D.flip_v = true
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "player" && start == false:
		print("start")
		start = true
		dir = GameUtils.DIR
	if body.is_in_group("mobs") && start == true:
		body.damage(3)
		


func _on_walldetect_body_entered(body):
	if body.name == "maintiles":
		self.queue_free()
