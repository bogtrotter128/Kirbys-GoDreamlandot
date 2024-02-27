extends VisibleOnScreenNotifier2D
func _ready():
	$"..".set_physics_process(false)
	$"..".set_process(false)

func _on_screen_entered():
	$"..".set_physics_process(true)
	$"..".set_process(true)

func _on_screen_exited():
	$"..".set_physics_process(false)
	$"..".set_process(false)
