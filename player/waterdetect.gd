extends Area2D

func _on_body_entered(body):
	if body.is_in_group("water"):
		$"..".swim = true
		$"..".parasolspawn = false
		$"..".mouthFullAir = false
		$"..".landed()
		$"../projectileProducer".inhaleStop()
		$"..".velocity.y = $"..".velocity.y /2

func _on_body_exited(body):
	if body.is_in_group("water"):
		$"..".swim = false
		if Input.is_action_pressed($"..".JUMP) or Input.is_action_pressed($"..".UP):
			$"..".jump_timer = $"..".jump_time_max
			$"..".is_jumping = false
			$"..".canJump = false
			$"..".velocity.y = -200
