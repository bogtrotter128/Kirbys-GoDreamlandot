extends Area2D

func _process(_delta):
	await get_tree().create_timer(3.5).timeout
	queue_free()

func _on_body_entered(body):
	if body.name == "player":
		body.damage()
		await get_tree().create_timer(0.2).timeout
