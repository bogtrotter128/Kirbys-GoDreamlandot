extends VisibleOnScreenNotifier2D

@export var gooeyrecall : PackedScene

func _on_screen_exited():
	GameUtils.secondplayerrecall = true
	$"..".queue_free()
