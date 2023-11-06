extends Area2D

var speed = 40

func _physics_process(delta):
	position += transform.x * speed * delta 
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
		#this will be a function that queue_free's the mob, and replaces them with an ice cube
#also need a fucntion to make ice damage bosses instead of ice cube them
#just add a damage function here
