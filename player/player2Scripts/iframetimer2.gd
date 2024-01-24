extends Timer

func _on_timeout():
	$"../frameflash".stop()
	$"../..".iframes = false
	GameUtils.IframesP2 = false
	print("NOIFRAMESP2")
	if $"../..".activeAbility > 0:
		$"../../AbilitySprites".visible=true
	else:
		$"../../AnimatedSprite2D".visible=true
