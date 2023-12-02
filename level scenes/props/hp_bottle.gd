extends CharacterBody2D

@export var gravityCheck = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#functions that DOES THE THINGGGGG
func _on_area_detect_body_entered(body):
	if body.name == "player":
		self.queue_free()
		#for 2p change this to body.whateverhealthfunctionImake
		GameUtils.HEALTH += 1
		body.HPHUD.update_health(GameUtils.HEALTH)


func _physics_process(delta):
	if gravityCheck == true:
		if not is_on_floor():
			if velocity.y < 200:
				velocity.y += gravity * delta
		move_and_slide()
