extends CharacterBody2D


var dir = 1
var SPEED = 60
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

@export var patrol = true
@export var copyAbilityScore = 0
@export var HP = 4

func _process(_delta):
	if HP <= 0:
		death()

func _physics_process(_delta):
	if $AnimatedSprite2D.animation != "dead":
		if not is_on_floor():
			velocity.y = move_toward(velocity.y, 200, 7)
		if patrol ==  true:
			velocity.x = move_toward(velocity.x, SPEED * dir, 4)
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
#adds wind blowing force
	if WINDFORCEX > 0 && velocity.x < WINDFORCEX or WINDFORCEX < 0 && velocity.x > WINDFORCEX:
		velocity.x = move_toward(velocity.x, velocity.x + WINDFORCEX, 5)
	if WINDFORCEY != 0:
		velocity.y = move_toward(velocity.y, WINDFORCEY, 16)
	move_and_slide()

func _on_wall_detect_body_entered(body):
	if body.name == "maintiles":
		dir = dir * -1
		$"wall detect/CollisionShape2D".call_deferred("set", "disabled", true)
		$detecttimer.start()

func _on_fall_detect_l_body_exited(body):
	if body.name == "maintiles":
		velocity.x = 0
		dir = dir * -1

func _on_fall_detect_r_body_exited(body):
	if body.name == "maintiles":
		velocity.x = 0
		dir = dir * -1

func _on_detecttimer_timeout():
	$"wall detect/CollisionShape2D".call_deferred("set", "disabled", false)

func death():
	velocity.x = 0
	velocity.y = -50 
	self.queue_free() 

func damage(value):
	HP -= value
	velocity.x = SPEED * dir * -1
	velocity.y = -200
