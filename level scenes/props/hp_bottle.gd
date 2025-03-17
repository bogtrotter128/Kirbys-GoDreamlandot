extends CharacterBody2D

@export var gravityCheck = false
@export var healamount = 1
var rng = RandomNumberGenerator.new()
var ranint = rng.randi_range(0,45)

func _ready():
	$Sprite2D.frame = ranint
#functions that DOES THE THINGGGGG
func _on_area_detect_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
		body.heal(healamount)

func _physics_process(_delta):
	if gravityCheck == true:
		if not is_on_floor():
			velocity.y = move_toward(velocity.y, 200, 7)
		move_and_slide()
