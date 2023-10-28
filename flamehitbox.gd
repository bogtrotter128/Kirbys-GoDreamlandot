extends Area2D

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		GameUtils.Iframes = true
		$"../../IframeTimer".set_wait_time(0.5)
		$"../../IframeTimer".start()
		body.damage(3)
		await get_tree().create_timer(0.1).timeout
