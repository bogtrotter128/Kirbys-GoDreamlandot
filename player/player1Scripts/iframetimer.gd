extends Timer

func _on_timeout():
	$"../frameflash".stop()
	$"../..".iframes = false
	if $"../..".is_in_group("player1"):
		GameUtils.Iframes = false
	elif $"../..".is_in_group("player2"):
		GameUtils.IframesP2 = false
	print("NOIFRAMES")
	if $"../..".activeAbility > 0:
		$"../../AbilitySprites".visible=true
	else:
		$"../../AnimatedSprite2D".visible=true
