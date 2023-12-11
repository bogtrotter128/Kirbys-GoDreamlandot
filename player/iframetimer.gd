extends Timer

func _on_timeout():
	$"../frameflash".stop()
	GameUtils.IframesP2 = false
	if $"../..".activeAbility > 0:
		$"../../AbilitySprites".visible=true
	else:
		$"../../AnimatedSprite2D".visible=true
