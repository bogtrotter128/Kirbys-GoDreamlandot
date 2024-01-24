extends Area2D

func damage():
	if GameUtils.Iframes == false && $"..".activeAbility != 4:
		GameUtils.Iframes = true
		GameUtils.HEALTH -= 1
		$"..".iframes = true
		$"..".hurt = true
		$"..".overrideX = false
		$"..".overrideY = false
		GameUtils.Killsuck = true
		GameUtils.KillAbility = true
		Hud.updatehp()
		$iframetimer.start()
		$frameflash.start()
		if $"..".activeAbility > 0:
			$"../projectileProducer".abilityStop()
		$"..".mouthFullAir = false
		$"..".flight = false
		$"..".slide = false
		$"..".inhaling = false
		$"..".overrideX = true
		$"..".velocity.x = 0
		$"..".velocity.x = 40 * (GameUtils.DIR * -1)
		$"..".velocity.y = -200
		await get_tree().create_timer(0.3).timeout
		$"..".hurt = false
		$"..".canJump = true
		$"..".canInhale = true
		$"..".overrideX = false
		$"..".overrideY = false

func _on_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("hazard"):
		damage()
func _on_area_entered(area):
	if area.is_in_group("mobs") or area.is_in_group("hazard"):
		damage()
