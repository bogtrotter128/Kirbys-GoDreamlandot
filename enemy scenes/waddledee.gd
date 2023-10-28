extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = 1
var SPEED = 70
var run
var runcheck
var sucked = false
var suckedSpeed = 0

@export var copyAbilityScore = 0
@export var HP = 4

func _process(_delta):
	if HP <= 0 && $AnimatedSprite2D.animation != "dead":
		death()

func _physics_process(delta):
	if $AnimatedSprite2D.animation != "dead":
		if not is_on_floor():
			velocity.y += gravity * delta
			velocity.y = velocity.y * 0.97
		if $AnimatedSprite2D.animation != "hurt":
			velocity.x = (SPEED * dir) + suckedSpeed
			
			if run == true:
				SPEED = 170 
				$AnimatedSprite2D.play("run")

			if run == false:
				SPEED = 70
				$AnimatedSprite2D.play("walk")
		if sucked == false:
			suckedSpeed = 0
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = false
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = true
	if sucked == true:
		print("SUCKED")
		for i in 200:
			suckedSpeed = (20 + i) * (GameUtils.DIR * -1)
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
	move_and_slide()

func _on_wall_detect_body_entered(body):
	if body.name == "maintiles":
		dir = dir * -1
		$"wall detect/CollisionShape2D".call_deferred("set", "disabled", true)
		$detecttimer.start()

func _on_fall_detect_l_body_exited(body):
	if body.name == "maintiles":
		dir = dir * -1

func _on_fall_detect_r_body_exited(body):
	if body.name == "maintiles":
		dir = dir * -1


func _on_detecttimer_timeout():
	$"wall detect/CollisionShape2D".call_deferred("set", "disabled", false)


func _on_player_detect_body_entered(body):
	if body.name == "player":
		run = true
		runcheck = true

func _on_player_detect_body_exited(body):
	if body.name == "player":
		runcheck = false
		await get_tree().create_timer(5).timeout
		if runcheck == false:
			run = false

func _on_hit_detect_body_entered(body):
	if body.name == "player":
		await get_tree().create_timer(0.1).timeout
		print("HIT KIRBY")
		if GameUtils.IframeHit == false:
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
	GameUtils.enemyHP = HP * 4
	$AnimatedSprite2D.play("hurt")
	velocity.x = SPEED * dir * -1
	velocity.y = -200
	$hitDetect.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	$hitDetect.call_deferred("set", "disabled", false)
	$AnimatedSprite2D.play("run")
