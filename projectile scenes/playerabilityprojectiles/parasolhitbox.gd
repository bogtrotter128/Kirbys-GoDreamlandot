extends Area2D
var abilityscore = 7
var floating = false
var canpuff = true
var airpuff = preload("res://projectile scenes/air_puff.tscn")

func _process(_delta):
	if get_parent().parasolspawn == false or get_parent().hasAbility == false:
		floatcheck(false)
		queue_free()
	if get_parent().parasolup == true:
		canpuff = true
		position.y = -15
		position.x = -5 * get_parent().DIR
	if get_parent().parasolup == false:
		position.y = 3
		position.x = 20 * get_parent().DIR
		if get_parent().run == true:
			summonpuff()
		floatcheck(false)
	if get_parent().crouch == true:
		position.y = 0
		position.x = 3 * get_parent().DIR
	if get_parent().parasolup == true && get_parent().swim == true:
		get_parent().parasolspawn = false
		floatcheck(false)
		queue_free()

func _input(_event):
	if Input.is_action_just_pressed(get_parent().UP) && get_parent().parasolup == true && get_parent().mouthFullAir == false:
		floatcheck(true)
	if Input.is_action_just_pressed(get_parent().DOWN) && floating == true:
		floatcheck(false)

func floatcheck(boo):
	floating = boo
	get_parent().parafloat = boo

func summonpuff():
	if canpuff == true:
		canpuff = false
		var puff = airpuff.instantiate()
		get_parent().add_sibling(puff)
		puff.transform = $"../projectileProducer".global_transform
		puff.position.x += 15 * get_parent().DIR
func _physics_process(_delta):
	if get_parent().is_on_floor():
		floatcheck(false)
	if floating == true:
		get_parent().velocity.y /= 1.3

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock") && get_parent().parasolup == false:
		body.blockbreak()
