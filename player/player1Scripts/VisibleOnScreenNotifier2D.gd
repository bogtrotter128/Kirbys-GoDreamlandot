extends VisibleOnScreenNotifier2D

func _on_screen_exited():
	if GameUtils.RECALL == false:
		GameUtils.RECALL = true
		GameUtils.firstplayerrecall = true
		$"..".queue_free()
