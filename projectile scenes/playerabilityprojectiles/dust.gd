extends Area2D
var speed = 0
func _ready():
	if speed < 0:
		global_position.x -= 10
	if speed > 0:
		global_position.x += 10
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()
		queue_free()
