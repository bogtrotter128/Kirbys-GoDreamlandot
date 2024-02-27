extends CharacterBody2D

@export var copyAbilityScore = 4
@export var HP = 2
@export var magmarock : PackedScene
var deathpoof = preload("res://enemy scenes/deathpoof/deathsprite.tscn")
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, 200, 7)
	move_and_slide()

var playerdetected = false
var canfire = false
func _process(_delta):
	if canfire == true:
		spout()
	if HP <= 0:
		death()

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("hot")
		playerdetected = true
		$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
		$cooloffTime.start()

func spout():
	canfire = false
	$AnimatedSprite2D.play("fire")
	var magma = magmarock.instantiate()
	add_sibling(magma)
	magma.transform = $Marker2D.global_transform

func _on_timer_timeout():
	if playerdetected == true:
		canfire = true

func death():
	velocity.x = 0
	velocity.y = -50 
	var poof = deathpoof.instantiate()
	call_deferred("add_sibling", poof)
	poof.global_transform = global_transform
	self.queue_free()

func damage(value):
	HP -= value

func _on_cooloff_time_timeout():
	playerdetected = false
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", false)
	await get_tree().create_timer(0.5).timeout
	if playerdetected == false:
		$AnimatedSprite2D.play("default")
