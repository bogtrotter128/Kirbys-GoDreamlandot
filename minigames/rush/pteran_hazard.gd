extends StaticBody2D
var dir = -1

func _process(_delta):
	if position.y > 140 or position.y < 0:
		dir *= -1
func _physics_process(_delta):
	position.y = move_toward(position.y, position.y + (10 * dir), 1.1)
	position.x = move_toward(position.x, position.x -100, 1)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
