extends Area2D

func _process(delta):
	position += transform.x * 123 * delta

func _on_body_entered(body):
	if body.name == "maintiles":
		self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()
