extends CharacterBody2D

var dir = -1
var SPEED = 70
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

var run
var runcheck
var fire = false
var hasFired = false
var canFire = true
var dead = false

@export var galboflame : PackedScene
@export var copyAbilityScore = 1
@export var HP = 5

func _process(_delta):
	if HP <= 0 && $AnimatedSprite2D.animation != "dead":
		death()
	#fires the fireblast, only if galbo hasnt already fired
	if fire && canFire == true:
		$AnimatedSprite2D.play("fire")
		await get_tree().create_timer(4.5).timeout
		canFire = true
		hasFired = false
		fire = false
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(0.2).timeout
		$fireRange/CollisionShape2D.call_deferred("set", "disabled", false)
	
func _physics_process(_delta):
	if $AnimatedSprite2D.animation != "dead":
		if not is_on_floor():
			velocity.y = move_toward(velocity.y, 200, 7)
		if canFire == true:
			if dir > 0:
				$AnimatedSprite2D.flip_h = true
				$projectileProducer.rotation_degrees = 180
				$projectileProducer.position.x = 10
			else:
				$AnimatedSprite2D.flip_h = false
				$projectileProducer.rotation_degrees = 0
				$projectileProducer.position.x = -10

#adds wind blowing force
	if WINDFORCEX > 0 && velocity.x < WINDFORCEX or WINDFORCEX < 0 && velocity.x > WINDFORCEX:
		velocity.x = move_toward(velocity.x, velocity.x + WINDFORCEX, 5)
	if WINDFORCEY != 0:
		velocity.y = move_toward(velocity.y, WINDFORCEY, 16)
	move_and_slide()

func _on_player_detect_l_body_entered(body):
	if body.is_in_group("player"):
		dir = -1
		if $AnimatedSprite2D.animation != "fire":
			$AnimatedSprite2D.play("awake")

func _on_player_detect_r_body_entered(body):
	if body.is_in_group("player"):
		dir = 1
		if $AnimatedSprite2D.animation != "fire":
			$AnimatedSprite2D.play("awake")

#this detects when the player has left galbo's sight
func _on_player_range_body_exited(body):
	if body.is_in_group("player") && canFire == true:
		if $AnimatedSprite2D.animation != "fire":
			$AnimatedSprite2D.play("idle")

func _on_fire_range_body_entered(body):
	if body.is_in_group("player") && fire == false:
		fire = true
		canFire = true

func fireBlast():
	canFire = false
	hasFired = true
	$fireRange/CollisionShape2D.call_deferred("set", "disabled", true)
#	await get_tree().create_timer(0.1).timeout
	var flame
	flame = galboflame.instantiate()
	add_child(flame)
	flame.transform = $projectileProducer.transform

func _on_hit_detect_body_entered(body):
	if body.is_in_group("player") && body.iframes == false:
		await get_tree().create_timer(0.15).timeout
		damage(1)

func damage(value):
	HP -= value
	GameUtils.enemyHP = HP * 4
	$AnimatedSprite2D.play("fire")
	velocity.x = SPEED * dir * -1
	velocity.y = -200
	$hitDetect.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	$hitDetect.call_deferred("set", "disabled", false)

func death():
	boxClear()
	velocity.x = 0
	velocity.y = -50 
	$AnimatedSprite2D.play("dead")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free() 

func boxClear():
	$hitDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$collisionbox.call_deferred("set", "disabled", true)
	$fireRange/CollisionShape2D.call_deferred("set", "disabled", true)
	$"playerDetect L/CollisionShape2D".call_deferred("set", "disabled", true)
	$"playerDetect R/CollisionShape2D".call_deferred("set", "disabled", true)
	$playerRange/CollisionShape2D.call_deferred("set", "disabled", true)


func _on_timer_timeout():
	if fire == true:
		fireBlast()
