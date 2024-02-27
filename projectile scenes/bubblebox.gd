extends Area2D

var speed = 40
var rng = RandomNumberGenerator.new()
var ranint = rng.randi_range(-20,20)

func _physics_process(delta):
	position += transform.y * ranint/100
	position += transform.x * speed * delta
	#put a random transform.y function here
	await get_tree().create_timer(0.6).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(1)
		queue_free()
	if body.is_in_group("powblock"):
		body.blockbreak()
		queue_free()
#also need a fucntion to make ice damage bosses instead of ice cube them
#just add a damage function here
