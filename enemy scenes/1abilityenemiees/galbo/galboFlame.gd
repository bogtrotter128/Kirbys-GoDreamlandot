extends Area2D

func _process(delta):
	position += transform.x * -120 * delta
	await get_tree().create_timer(0.2).timeout
	queue_free()

func damage(_num):
	queue_free()

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("player") or body.name == "maintiles" or body.is_in_group("projectiles") or body.is_in_group("powblock"):
		await get_tree().create_timer(0.02).timeout
		queue_free()
func _on_area_entered(area):
	if area == null:
		pass
	if area.is_in_group("player") or area.is_in_group("projectiles"):
		queue_free()
