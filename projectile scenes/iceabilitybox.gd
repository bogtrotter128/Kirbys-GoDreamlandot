extends Area2D

var speed = 50
var rng = RandomNumberGenerator.new()
var ranint = rng.randi_range(-40,40)
var changedY = false
@export var icecube : PackedScene


func _physics_process(delta):
	position += transform.y * ranint/100
	position += transform.x * speed * delta
	#put a random transform.y function here
	await get_tree().create_timer(0.6).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		var ice
		ice = icecube.instantiate()
		ice.position = Vector2((body.global_position.x - 56.0),body.global_position.y)
		call_deferred("add_sibling", ice)
		body.queue_free()
	if body.is_in_group("powblock"):
		body.blockbreak()
#also need a fucntion to make ice damage bosses instead of ice cube them
#just add a damage function here
