extends Timer

func _on_timeout():
	$"../frameflash".stop()
	$"../..".iframes = false
	GameUtils.Iframes = false
	print("NOIFRAMES")
	if $"../..".activeAbility > 0:
		$"../../AbilitySprites".visible=true
	else:
		$"../../AnimatedSprite2D".visible=true
