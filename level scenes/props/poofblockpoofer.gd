extends Area2D

func _ready():
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("poofblock"):
		body.blockpoof()
