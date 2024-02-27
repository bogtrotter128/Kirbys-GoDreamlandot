extends Area2D

func _process(_delta):
	if get_parent().slide == false:
		queue_free()

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(1)
	if body.is_in_group("powblock"):
		body.blockbreak()
