extends AnimatedSprite2D

func _ready():
	await animation_finished
	queue_free()
