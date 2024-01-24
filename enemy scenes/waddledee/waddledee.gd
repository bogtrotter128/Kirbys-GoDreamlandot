extends CharacterBody2D

var dir = 1
var SPEED = 60
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

var run
var runcheck

@export var copyAbilityScore = 0
@export var HP = 4

func _process(_delta):
	if HP <= 0 && $AnimatedSprite2D.animation != "dead":
		death()

func _physics_process(_delta):
	if $AnimatedSprite2D.animation != "dead":
		if not is_on_floor():
			velocity.y = move_toward(velocity.y, 200, 7)
		if $AnimatedSprite2D.animation != "hurt":
			velocity.x = move_toward(velocity.x, SPEED * dir, 4)
			
			if run == true:
				SPEED = 140 
				$AnimatedSprite2D.play("run")

			if run == false:
				SPEED = 60
				$AnimatedSprite2D.play("walk")

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


func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		run = true
		runcheck = true

func _on_player_detect_body_exited(body):
	if body.is_in_group("player"):
		runcheck = false
		await get_tree().create_timer(5).timeout
		if runcheck == false:
			run = false

func _on_hit_detect_body_entered(body):
	if body.is_in_group("player") && body.iframes == false:
		await get_tree().create_timer(0.15).timeout
		damage(1)

func death():
	boxClear()
	velocity.x = 0
	velocity.y = -50 
	$AnimatedSprite2D.play("dead")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free() 

func boxClear():
	$CollisionShape2D.call_deferred("set", "disabled", true)
	$hitDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$"wall detect/CollisionShape2D".call_deferred("set", "disabled", true)
	$"fall detect R/CollisionShape2D".call_deferred("set", "disabled", true)
	$"fall detect L/CollisionShape2D".call_deferred("set", "disabled", true)

func damage(value):
	HP -= value
	$AnimatedSprite2D.play("hurt")
	velocity.x = SPEED * dir * -1
	velocity.y = -200
	$hitDetect.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	$hitDetect.call_deferred("set", "disabled", false)
	dir = dir * -1
	$AnimatedSprite2D.play("run")

