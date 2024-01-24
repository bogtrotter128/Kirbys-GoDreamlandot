extends CharacterBody2D
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

@export var copyAbilityScore = 4
@export var HP = 2
@export var magmarock : PackedScene
func _physics_process(_delta):
	if not is_on_floor():
			velocity.y = move_toward(velocity.y, 200, 7)
	#adds wind blowing force
	if WINDFORCEX > 0 && velocity.x < WINDFORCEX or WINDFORCEX < 0 && velocity.x > WINDFORCEX:
		velocity.x = move_toward(velocity.x, velocity.x + WINDFORCEX, 5)
	if WINDFORCEY != 0:
		velocity.y = move_toward(velocity.y, WINDFORCEY, 16)
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
		$AnimatedSprite2D.play("fire")
		playerdetected = true
		$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
		$cooloffTime.start()

func spout():
	canfire = false
	var magma = magmarock.instantiate()
	add_sibling(magma)
	magma.transform = $Marker2D.global_transform

func _on_timer_timeout():
	if playerdetected == true:
		canfire = true

func death():
	self.queue_free() 

func damage(value):
	HP -= value

func _on_cooloff_time_timeout():
	playerdetected = false
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", false)
	await get_tree().create_timer(0.5).timeout
	if playerdetected == false:
		$AnimatedSprite2D.play("default")
