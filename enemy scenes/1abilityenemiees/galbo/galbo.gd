extends CharacterBody2D

@export var dir = -1

var fire = false
var hasFired = false
var canFire = true
var deathpoof = preload("res://enemy scenes/deathpoof/deathsprite.tscn")
@export var galboflame : PackedScene
@export var copyAbilityScore = 1
@export var HP = 5

func _process(_delta):
	if HP <= 0:
		death()
	#fires the fireblast, only if galbo hasnt already fired
	if fire && canFire == true:
		$AnimatedSprite2D.play("fire")
		await get_tree().create_timer(3).timeout
		canFire = true
		hasFired = false
		fire = false
		$AnimatedSprite2D.play("default")
		await get_tree().create_timer(1.4).timeout
		$fireRange/CollisionShape2D.call_deferred("set", "disabled", false)
	
func _physics_process(_delta):
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
			$AnimatedSprite2D.play("default")

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

func death():
	velocity.x = 0
	velocity.y = -50
	$AnimatedSprite2D.play("fire")
	var poof = deathpoof.instantiate()
	call_deferred("add_sibling", poof)
	poof.global_transform = global_transform
	self.queue_free()

func damage(value):
	$AnimatedSprite2D.play("hurt")
	velocity.y = -200
	HP -= value

func _on_timer_timeout():
	if fire == true:
		fireBlast()
