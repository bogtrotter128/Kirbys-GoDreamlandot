extends AnimatedSprite2D

var anistarted = false
var upani = false
var normani = false
var runani = false

func _process(_delta):
	if $"..".activeAbility > 0:
		abilityanimations()
		visible=true
	else:
		visible=false
		anistarted = false
		upani = false
		normani = false
		runani = false
		
func abilityanimations():
#fire ability animations
	if $"..".activeAbility == 1 && anistarted == false:
		if upani == true:
			play("fireup start")
			await animation_finished
			play("fireup")
		if runani == true:
			play("fireburst start")
			await animation_finished
			play("fireburst")
		if normani == true:
			play("fireblow")
		anistarted = true
	
#shock ability animaions
	if $"../projectileProducer".shockstart == true:
		play("shockstart")
	if $"..".activeAbility == 2 && $"../projectileProducer".shockstart == false:
		play("shockloop")

#ice ability animaions
	if $"..".activeAbility == 3 && anistarted == false:
		if upani == true:
			play("iceupstart")
			await animation_finished
			play("iceup")
		if upani == false:
			play("icestart")
			await animation_finished
			play("iceloop")
		anistarted = true

#stone ability animations
	if $"..".activeAbility == 4:
		if not $"..".is_on_wall():
			$".".play("rockstart")
		if $"..".velocity.y == 0:
			$".".play("rockstart")
		if $"..".is_on_wall():
			if $"..".velocity.y > 0 or $"..".velocity.y < 0:
				$".".play("rockloop")


#spike ability animaions
	if $"../projectileProducer".spikestart == true:
		$".".play("spikestart")
	if $"..".activeAbility == 5 && $"../projectileProducer".spikestart == false:
		$".".play("spikeloop")

# cutter ability animations
	if $"../projectileProducer".cutterstart == true:
		play("cutter")
#parasol
	if $"..".activeAbility == 7:
		play("parasol")
#broom
	if $"..".activeAbility == 8:
		if $"..".run == false:
			play("sweep")
		if $"..".run == true:
			play("sweepswipe")
