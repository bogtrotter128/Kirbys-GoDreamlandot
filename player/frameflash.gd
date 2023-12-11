extends Timer


func flash():
	#flashes ability sprites if active
	if $"../..".activeAbility > 0:
		$"../../AbilitySprites".visible=false
		await get_tree().create_timer(0.15).timeout
		if $"../..".activeAbility > 0:
			$"../../AbilitySprites".visible=true
	#flashes the normal sprites
	elif $"../..".activeAbility == 0:
		$"../../AnimatedSprite2D".visible=false
		await get_tree().create_timer(0.15).timeout
		if $"../..".activeAbility == 0:
			$"../../AnimatedSprite2D".visible=true
func _on_timeout():
	flash()
