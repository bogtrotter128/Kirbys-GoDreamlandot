extends Area2D

var speed = 70

@export var icecube : PackedScene

func _physics_process(delta):
	if GameUtils.DIR == -1:
		$AnimatedSprite2D.flip_v = true
		
	position += transform.x * speed * delta
	#put a random transform.y function here
	await get_tree().create_timer(0.6).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		GameUtils.icecubespawn = true
		#this will be a function that queue_free's the mob, and replaces them with an ice cube
		var icecubespawn = icecube.instantiate()
	#this here uses call deffered to summon the icecube, godot just told me to use this instead idky
		call_deferred("add_child", icecubespawn)
		icecubespawn.transform = body.global_transform
		GameUtils.icecubespawn = false
		body.queue_free()
#also need a fucntion to make ice damage bosses instead of ice cube them
#just add a damage function here
