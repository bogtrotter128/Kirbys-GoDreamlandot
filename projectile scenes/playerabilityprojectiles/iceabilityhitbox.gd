extends Node2D
var snowpowder = preload("res://projectile scenes/playerabilityprojectiles/iceabilitysnow.tscn")
var icecube = preload("res://projectile scenes/playerabilityprojectiles/icecube.tscn")
var abilityinuse = false
var snowblowready = true
var blower = false

func _input(_event):
	if Input.is_action_pressed(get_parent().UP) && Input.is_action_pressed(get_parent().A) && abilityinuse == false:
		abilityinuse = true
		$"../AbilitySprites".upani = true
		get_parent().activeAbility = 3
		blizzard()
	if Input.is_action_just_released(get_parent().A) or get_parent().hurt == true:
		abilityinuse = false
		stop()
func _process(_delta):
	#blow snow powder
	if Input.is_action_pressed(get_parent().A) && get_parent().mouthFullAir == false && get_parent().abilityCooldown == false && abilityinuse == false && get_parent().crouch == false:
		abilityinuse = true
		$"../AbilitySprites".normani = true
		get_parent().activeAbility = 3
		blower = true
	#culler
	if get_parent().hasAbility == false or get_parent().iceabilityready == false:
		$snowblowtimer.stop()
		get_parent().iceabilityready = false
		queue_free()

func _physics_process(_delta):
	if blower == true && snowblowready == true: #blows the snow particles
		snowblow()
	if get_parent().run == true:
		get_parent().iceskate = true
		get_parent().SPEEDELTA = 2
	else:
		get_parent().SPEEDELTA = 4
		get_parent().iceskate = false
	#ice cube crouch shield
	if get_parent().crouch == true:
		get_parent().normaldamageguard = true
	else:
		get_parent().normaldamageguard = false

func blizzard():
	$blizzardbody/CollisionShape2D.call_deferred("set", "disabled",false)

func snowblow():
	snowblowready = false
	var snow = snowpowder.instantiate()
	get_parent().call_deferred("add_sibling", snow)
	snow.transform = $"../projectileProducer".global_transform
func _on_snowblowtimer_timeout():
	snowblowready = true
func stop():
	get_parent().activeAbility = 0
	blower = false
	$blizzardbody/CollisionShape2D.call_deferred("set", "disabled",true)

func _on_blizzardbody_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		var ice = icecube.instantiate()
		ice.position = Vector2((body.global_position.x - 56.0),body.global_position.y)
		get_parent().call_deferred("add_sibling", ice)
		body.queue_free()
	if body.is_in_group("powblock"):
		body.blockbreak()
