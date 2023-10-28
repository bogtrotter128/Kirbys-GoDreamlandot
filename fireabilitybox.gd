extends Area2D

func _process(_delta):
	if GameUtils.Killflame == true:
		self.queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(3)
		await get_tree().create_timer(0.1).timeout