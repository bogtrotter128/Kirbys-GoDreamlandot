extends Node2D
@export var dustspawn : PackedScene
var keeprun = false
func _ready():
	if get_parent().run == true:
		keeprun = true
		$Area2D/CollisionShape2D.call_deferred("set","disabled",false)
	if get_parent().run == false:
		sweep()

func _physics_process(_delta):
	if get_parent().activeAbility != 8 or not Input.is_action_pressed(get_parent().A):
		get_parent().run = false
		await get_tree().create_timer(0.05).timeout
		queue_free()
	get_parent().run = keeprun

func sweep():
	var dust
	dust = dustspawn.instantiate()
	dust.speed = 60
	get_parent().add_sibling(dust)
	dust.global_transform = global_transform
	dust.global_position.y += 8

func _on_timer_timeout():
	if get_parent().run == false:
		sweep()

func _on_area_2d_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()
