extends Area2D

var speed = 80

func _physics_process(delta):
	if GameUtils.DIR == -1:
		$Sprite2D.flip_v = true
	position += transform.x * speed * delta 
	await get_tree().create_timer(0.3).timeout
	queue_free()

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(1)
		await get_tree().create_timer(0.02).timeout
		queue_free()
