extends Area2D
@export var dustspawn : PackedScene
func _process(_delta):
	if is_in_group("player2"):
		self.queue_free()
	if is_in_group("player1"):
		self.queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()
var canfire = true
func _on_floordetect_body_entered(body):
	if body.name == "maintiles" && canfire == true:
		canfire = false
		await get_tree().create_timer(0.1).timeout
		dustShoot(40)
		dustShoot(-40)
		await get_tree().create_timer(0.1).timeout
		dustShoot(40)
		dustShoot(-40)

func dustShoot(speed):
	var dust = dustspawn.instantiate()
	dust.speed = speed
	get_parent().add_sibling(dust)
	dust.global_transform = global_transform
	dust.global_position.y += 10
