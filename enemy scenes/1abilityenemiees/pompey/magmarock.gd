extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var xdist = 0
var jumpcount = 0
var copyAbilityScore = 4
func _ready():
	rng.randomize()
	xdist = rng.randi_range(-80,80)
	velocity.y += -240

#spins the rock around
func _process(_delta):
	$Sprite2D.rotation_degrees = move_toward($Sprite2D.rotation_degrees,$Sprite2D.rotation_degrees + 10,3)
	if jumpcount >= 2:
		queue_free()
func _physics_process(_delta):
	velocity.x = move_toward(velocity.x, xdist,7)
	if is_on_floor():
		velocity.y += -80 + (20 * jumpcount)
		jumpcount += 1
	else:
		velocity.y = move_toward(velocity.y, 200, 7)
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("projectiles"):
		await get_tree().create_timer(0.09).timeout
		queue_free()

func damage(_num):
	queue_free()
