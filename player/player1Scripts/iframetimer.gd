extends Timer

func _on_timeout():
	$"../frameflash".stop()
	$"../..".iframes = false
	$"../damshape".call_deferred("set","disabled", false)
	print("NOIFRAMES")
	if $"../..".activeAbility > 0:
		$"../../AbilitySprites".visible=true
	else:
		$"../../AnimatedSprite2D".visible=true
