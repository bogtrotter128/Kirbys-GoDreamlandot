extends Area2D

@export var dustspawn : PackedScene

func _process(_delta):
	if is_in_group("player2") && GameUtils.KillAbilityP2 == true:
		self.queue_free()
	if is_in_group("player1") && GameUtils.KillAbility == true:
		self.queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(3)
		await get_tree().create_timer(0.1).timeout
	if body.is_in_group("powblock"):
		body.blockbreak()

func _on_floordetect_body_entered(body):
	if body.name == "maintiles":
		await get_tree().create_timer(0.1).timeout
		dustShoot(40)
		dustShoot(-40)
		await get_tree().create_timer(0.1).timeout
		dustShoot(40)
		dustShoot(-40)

func dustShoot(speed):
	var dust
	dust = dustspawn.instantiate()
	dust.speed = speed
	add_sibling(dust)
	dust.transform = $".".global_transform
