extends CharacterBody2D
@export var gravityCheck = false
@export var starValue = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if starValue == 1:
		$AnimatedSprite2D.play("small")
	elif starValue == 2:
		$AnimatedSprite2D.play("medi")
	elif starValue == 3:
		$AnimatedSprite2D.play("large")

#functions that DOES THE THINGGGGG
func _on_area_detect_body_entered(body):
	if body.name == "player":
		self.queue_free()
		#for 2p change this to body.whateverhealthfunctionImake
		GameUtils.STARS += starValue
		body.Starbar.update_stars(GameUtils.STARS)


func _physics_process(delta):
	if gravityCheck == true:
		if not is_on_floor():
			if velocity.y < 200:
				velocity.y += gravity * delta
		move_and_slide()
