extends AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $"..".activeAbility > 0:
		$".".visible=true
	else:
		$".".visible=false


#fire ability animations
	var firescoreS = $"../projectileProducer".firescore
	if $"../projectileProducer".firestart == true:
		$".".play("firestart")
	if $"..".activeAbility == 1 && $"../projectileProducer".firestart == false:
		if firescoreS >= 21:
			# strong fire
			$".".play("firestrong")
		elif firescoreS > 10 && firescoreS < 21:
			# mid fire
			$".".play("firemid")
		elif firescoreS <= 10:
			# small fire
			$".".play("firesmall")
	
#shock ability animaions
	if $"../projectileProducer".shockstart == true:
		$".".play("shockstart")
	if $"..".activeAbility == 2 && $"../projectileProducer".shockstart == false:
		$".".play("shockloop")

#ice ability animaions
	if $"../projectileProducer".icestart == true:
		$".".play("icestart")
	if $"..".activeAbility == 3 && $"../projectileProducer".icestart == false:
		$".".play("iceloop")

#stone ability animations
	if $"..".activeAbility == 4:
		if $"..".velocity.y == 0:
			$".".play("rockstart")
		if $"..".is_on_wall():
			if $"..".velocity.y > 0 or $"..".velocity.y < 0:
				$".".play("rockloop")
		if not $"..".is_on_wall() && $".".animation == "rockloop":
			$".".play("rockstart")

#spike ability animaions
	if $"../projectileProducer".spikestart == true:
		$".".play("spikestart")
	if $"..".activeAbility == 5 && $"../projectileProducer".spikestart == false:
		$".".play("spikeloop")

# cutter ability animations
	if $"../projectileProducer".cutterstart == true:
		play("cutter")
#parasol

#broom
