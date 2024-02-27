extends Area2D

func damage():
	$"..".iframes = true
	if $"..".is_in_group("player1"):
		GameUtils.HEALTH -= 1
		Hud.updatehp()
	if $"..".is_in_group("player2"):
		GameUtils.HEALTHP2 -= 1
		Hud.updatehp2()
	$"..".hurt = true
	$damshape.call_deferred("set","disabiled",true)
	$iframetimer.start()
	$frameflash.start()
	$"../animalfriendcode".abilityStop()
	$"..".inhaling = false
	$"..".overrideX = true
	$"..".velocity.x = 40 * ($"..".DIR * -1)
	if $"..".swim == false:
		$"..".velocity.y = -100
	if $"..".swim == true:
		$"..".velocity.y = -40
	await get_tree().create_timer(0.3).timeout
	$"..".hurt = false
	$"..".canJump = true
	$"..".canInhale = true
	$"..".overrideX = false
	$"..".overrideY = false

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs") && $"..".iframes == false && $"..".normaldamageguard == false:
		damage()
		body.damage(1)
	if body.is_in_group("hazard") && $"..".iframes == false:
		damage()
func _on_area_entered(area):
	if area == null:
		pass
	if area.is_in_group("mobs") && $"..".iframes == false or area.is_in_group("hazard") && $"..".iframes == false:
		damage()
