extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func damage():
	if GameUtils.Iframes == false && $"..".activeAbility != 4:
		$"..".hurt = true
		$"..".overrideX = false
		$"..".overrideY = false
		GameUtils.Killsuck = true
		GameUtils.KillAbility = true
		GameUtils.Iframes = true
		Hud.updatehp2()
		GameUtils.HEALTH -= 1
		$iframetimer.start()
		$frameflash.start()
		$"..".activeAbility = 0
		if $"..".activeAbility > 0:
			$"../projectileProducer".abilityStop()
		$"..".mouthFullAir = false
		$"..".flight = false
		$"..".slide = false
		$"..".overrideX = true
		$"..".velocity.x = 0
		$"..".velocity.x = $"..".SPEED * (GameUtils.DIR * -1.75)
		$"..".velocity.y = -200
		await get_tree().create_timer(0.3).timeout
		$"..".hurt = false
		$"..".canJump = true
		$"..".overrideX = false
		$"..".overrideY = false

func _on_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("hazard"):
		damage()
