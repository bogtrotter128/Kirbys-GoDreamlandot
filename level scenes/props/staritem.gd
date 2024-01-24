extends CharacterBody2D
@export var gravityCheck = false
@export var starValue = 1

func _ready():
	if starValue == 1:
		$AnimatedSprite2D.play("small")
	elif starValue == 2:
		$AnimatedSprite2D.play("medi")
	elif starValue == 3:
		$AnimatedSprite2D.play("large")

#functions that DOES THE THINGGGGG
func _on_area_detect_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
		GameUtils.STARS += starValue
		Hud.updatestarbar()

func _physics_process(_delta):
	if gravityCheck == true:
		if not is_on_floor():
			velocity.y = move_toward(velocity.y, 200, 7)
		move_and_slide()
