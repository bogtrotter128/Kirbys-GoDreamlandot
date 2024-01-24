extends Area2D

var speed = 40

func _ready():
	if speed < 0:
		global_position.x -= 10
	else:
		global_position.x += 10

func _physics_process(delta):
	position += transform.x * speed * delta
	await get_tree().create_timer(0.4).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(3)
		await get_tree().create_timer(0.1).timeout
