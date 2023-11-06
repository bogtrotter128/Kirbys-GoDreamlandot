extends Area2D

var speed = 234

func _physics_process(delta):
	position += transform.x * speed * delta 


func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(5)
		await get_tree().create_timer(0.2).timeout
		queue_free()

func _on_walldetect_body_entered(body):
	if body.name == "maintiles":
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
