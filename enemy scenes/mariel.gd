extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = 1
var SPEED = 90
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

var runcheckL
var runcheckR
var sucked = false
var suckedSpeed = 1
var chase = false
var player
var jump = false
var direction = 0

@export var copyAbilityScore = -1
@export var HP = 10

func _ready():
	velocity.x = 0
	$hitDetect/CollisionShape2D.disabled=true
	$AnimatedSprite2D.play("hide")
	$"chaseDetect L"/CollisionShape2D.disabled=true
	$"chaseDetect R/CollisionShape2D".disabled=true
func _process(_delta):
	if HP <= 0:
		death()

func _physics_process(delta):
	
	if $AnimatedSprite2D.animation != "dead":
		if chase == false and $AnimatedSprite2D.animation != "apear":
			$AnimatedSprite2D.play("hide")
			$playerDetect/CollisionShape2D.disabled=false
			$"chaseDetect L"/CollisionShape2D.disabled=true
			$"chaseDetect R/CollisionShape2D".disabled=true
			$hitDetect/CollisionShape2D.disabled=true
			jump = false
			velocity.x = 0
		if jump == true:
			velocity.y = -200
		
		if not is_on_floor():
			velocity.y += gravity * delta
			velocity.y = velocity.y * 0.97
		if $AnimatedSprite2D.animation != "hurt":
			if chase == true:
				$AnimatedSprite2D.play("walk")
				velocity.x = (SPEED * direction) + suckedSpeed
				if sucked == false:
					suckedSpeed = 0
					if direction < 0:
						$AnimatedSprite2D.flip_h = false
					else:
						$AnimatedSprite2D.flip_h = true
			if sucked == true:
				print("SUCKED")
				for i in 200:
					suckedSpeed = (20 + i) * (GameUtils.DIR * -1)
				if direction < 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
#adds wind blowing force
	velocity.x += WINDFORCEX * (delta * 5)
	velocity.y += WINDFORCEY * (delta * 2.5)
#this if statement makes sure kirby doesnt fall through Y wind
	if WINDFORCEY != 0 && velocity.y > 90:
		velocity.y = 50
	move_and_slide()
	
	
func death():
	velocity.x = 0
	boxClear() 
	$AnimatedSprite2D.play("dead")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free() 
	
func boxClear():
	$CollisionShape2D.call_deferred("set", "disabled", true)
	$hitDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$"chaseDetect L"/CollisionShape2D.call_deferred("set", "disabled", true)
	$"chaseDetect R/CollisionShape2D".call_deferred("set", "disabled", true)

func damage(value):
	HP -= value
	GameUtils.enemyHP = HP * 1.6
	velocity.x = SPEED * dir * -1
	velocity.y = -200
	$hitDetect.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	$hitDetect.call_deferred("set", "disabled", false)
	$AnimatedSprite2D.play("walk")
	appear()



func _on_hit_detect_body_entered(body):
	if body.name == "player":
		await get_tree().create_timer(0.1).timeout
		if GameUtils.IframeHit == false:
			damage(1)
			await get_tree().create_timer(0.1).timeout
			jump = true

func _on_hit_detect_body_exited(body):
	if body.name == "player":
		await get_tree().create_timer(0.1).timeout
		jump = false

func _on_player_detect_body_entered(body):
	if body.name == "player":
		appear()
		
func appear():
	print("APPEARIFY")
	$AnimatedSprite2D.play("apear")
	await $AnimatedSprite2D.animation_finished
	$"chaseDetect L/CollisionShape2D".call_deferred("set", "disabled", false)
	$"chaseDetect R/CollisionShape2D".call_deferred("set", "disabled", false)
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$hitDetect/CollisionShape2D.call_deferred("set", "disabled", false)
	chase = true

func _on_wall_detect_body_entered(body):
	#detects if theres a wall and then make teh spider jump
	if body.name == "maintiles" && chase == true:
		jump = true


func _on_wall_detect_body_exited(body):
	if body.name == "maintiles":
		jump = false



func _on_chase_detect_l_body_entered(body):
	if body.name == "player":
		chase = true
		runcheckL = true
		await get_tree().create_timer(0.2).timeout
		direction = -1

func _on_chase_detect_l_body_exited(body):
	if body.name == "player":
		await get_tree().create_timer(3).timeout
		runcheckL = false
		await get_tree().create_timer(2).timeout
		if runcheckR && runcheckL == false:
			chase = false
			direction = 0


func _on_chase_detect_r_body_entered(body):
	if body.name == "player":
		chase = true
		runcheckR = true
		await get_tree().create_timer(0.2).timeout
		direction = 1


func _on_chase_detect_r_body_exited(body):
	if body.name == "player":
		await get_tree().create_timer(3).timeout
		runcheckR = false
		await get_tree().create_timer(2).timeout
		if runcheckR && runcheckL == false:
			chase = false
			direction = 0
