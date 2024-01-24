extends Area2D

func _process(delta):
	position += transform.x * -100 * delta
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player") or body.name == "maintiles":
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
