extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var gravityCheck = false
@export var healamount = 1

#functions that DOES THE THINGGGGG
func _on_area_detect_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
		body.heal(healamount)

func _physics_process(delta):
	if gravityCheck == true:
		if not is_on_floor():
			if velocity.y < 200:
				velocity.y += gravity * delta
		move_and_slide()
