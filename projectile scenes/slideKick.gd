extends Area2D

func _process(_delta):
	if get_parent().name == "Player2":
		if GameUtils.KillsuckP2 == true:
			self.queue_free()
	if get_parent().name == "player":
		if GameUtils.Killsuck == true:
			self.queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(1)
		await get_tree().create_timer(0.2).timeout
