extends CharacterBody2D
#generic flying script
var SPEED = 70
var chase = false
var velocityturn = true
@export var dirX = 1
@export var dirY = 0
@export var copyAbilityScore = 0
@export var HP = 2
var deathpoof = preload("res://enemy scenes/deathpoof/deathsprite.tscn")
var screennotif = preload("res://enemy scenes/enemy_visible_on_screen_notifier_2d.tscn")

func _ready():
	var screennotifer = screennotif.instantiate()
	call_deferred("add_child", screennotifer)

func _process(_delta):
	if chase == true:
		targetmath()
	if velocity.x < 0 && velocityturn == true:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0 && velocityturn == true:
		$AnimatedSprite2D.flip_h = true
	if HP <= 0:
		death()

func _physics_process(_delta):
	if chase == false:
		flight()
	if chase == true:
		follow(chaseX,chaseY)
	if is_on_floor():
		velocity.y += -80
	move_and_slide()

func flight():
	velocity.x = move_toward(velocity.x,SPEED * dirX, 4)
	velocity.y = move_toward(velocity.y,SPEED * dirY, 4)

var chaseX = 1
var chaseY = 1
func follow(chasedirX, chasedirY):
	velocity.x = move_toward(velocity.x,SPEED * chasedirX, 4)
	velocity.y = move_toward(velocity.y,SPEED * chasedirY, 4)

var tempos
var tempos2
func targetmath():
	tempos = global_position.x - GameUtils.posX
	tempos2 = global_position.x - GameUtils.posXP2
	if tempos < 0:
		tempos *= -1
	if tempos2 < 0:
		tempos2 *= -1
	
	if tempos < tempos2:
		if GameUtils.posX < global_position.x:
			chaseX = -1
		elif GameUtils.posX > global_position.x:
			chaseX =  1
		if GameUtils.posY - 8 < global_position.y:
			chaseY = -1
		elif GameUtils.posY - 8 > global_position.y:
			chaseY =  1
	elif tempos > tempos2:
		if GameUtils.posXP2 < global_position.x:
			chaseX = -1
		elif GameUtils.posXP2 > global_position.x:
			chaseX =  1
		if GameUtils.posYP2 - 8 < global_position.y:
			chaseY = -1
		elif GameUtils.posYP2 - 8 > global_position.y:
			chaseY =  1

func _on_fliptimer_timeout():
	dirX *= -1

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		chase = true

func _on_player_detect_body_exited(body):
	if body.is_in_group("player"):
		chase = false

func _on_walldetect_x_body_entered(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		dirX *= -1
		$walldetectX/CollisionShape2D.call_deferred("set", "disabled", true)
		await get_tree().create_timer(0.3).timeout
		$walldetectX/CollisionShape2D.call_deferred("set", "disabled", false)

func _on_walldetect_y_body_entered(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		dirY *= -1
		$walldetectY/CollisionShape2D.call_deferred("set", "disabled", true)
		await get_tree().create_timer(0.3).timeout
		$walldetectY/CollisionShape2D.call_deferred("set", "disabled", false)

func death():
	velocity.x = 0
	velocity.y = -50 
	var poof = deathpoof.instantiate()
	call_deferred("add_sibling", poof)
	poof.global_transform = global_transform
	self.queue_free()

func damage(value):
	$AnimatedSprite2D.play("hurt")
	velocity.x = SPEED * dirX * -1
	velocity.y = -120
	HP -= value
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.play("default")
