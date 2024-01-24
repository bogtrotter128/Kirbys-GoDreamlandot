extends Area2D

func _ready():
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()
