extends Node2D

var dir = -1
func _process(_delta):
	for i in get_child_count():
		if get_child(i).global_position.y > 140 or get_child(i).global_position.y < -10:
			dir *= -1
func _physics_process(_delta):
	for i in get_child_count():
		get_child(i).global_position.y = move_toward(get_child(i).global_position.y, get_child(i).global_position.y + (100 * dir), 1.1)
		get_child(i).global_position.x = move_toward(get_child(i).global_position.x, get_child(i).global_position.x -100, 1)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
