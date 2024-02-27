extends Area2D
var abilityscore = 3
var speed = 80
var rng = RandomNumberGenerator.new()
var ranint = rng.randi_range(-40,40)
var changedY = false
@export var icecube : PackedScene


func _physics_process(delta):
	position += transform.y * ranint/100
	position += transform.x * speed * delta
	#put a random transform.y function here
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		var ice
		ice = icecube.instantiate()
		ice.position = Vector2((body.global_position.x - 56.0),body.global_position.y)
		call_deferred("add_sibling", ice)
		body.queue_free()
		queue_free()
	if body.is_in_group("powblock"):
		body.blockbreak()
		queue_free()
#also need a fucntion to make ice damage bosses instead of ice cube them
#just add a damage function here
