extends CharacterBody2D

const SPEED = 70
@export var dirX = 1
@export var dirY = 1
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

@export var HP = 2
var chase = false
var copyAbilityScore = 0

func _process(_delta):
	if chase == true:
		targetmath()
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if HP <= 0 && $AnimatedSprite2D.animation != "dead":
		death()

func _physics_process(_delta):
	if chase == false:
		flight()
	if chase == true:
		follow(chaseX,chaseY)
	
	if is_on_floor():
		velocity.y += -80
	
	if WINDFORCEX > 0 && velocity.x < WINDFORCEX or WINDFORCEX < 0 && velocity.x > WINDFORCEX:
		velocity.x = move_toward(velocity.x, velocity.x + WINDFORCEX, 5)
	if WINDFORCEY != 0:
		velocity.y = move_toward(velocity.y, WINDFORCEY, 16)
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
	if chase == false:
		dirX *= -1


func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		chase = true

func _on_player_detect_body_exited(body):
	if body.is_in_group("player"):
		chase = false

func _on_walldetect_x_body_entered(body):
	if body.name == "maintiles" && chase == false:
		dirX *= -1
		$walldetectX/CollisionShape2D.call_deferred("set", "disabled", true)
		await get_tree().create_timer(0.3).timeout
		$walldetectX/CollisionShape2D.call_deferred("set", "disabled", false)

func _on_walldetect_y_body_entered(body):
	if body.name == "maintiles" && chase == false:
		dirY *= -1
		$walldetectY/CollisionShape2D.call_deferred("set", "disabled", true)
		await get_tree().create_timer(0.3).timeout
		$walldetectY/CollisionShape2D.call_deferred("set", "disabled", false)

func _on_hit_detect_body_entered(body):
	if body.is_in_group("player") && body.iframes == false:
		await get_tree().create_timer(0.15).timeout
		damage(1)

func death():
	boxClear()
	velocity.x = 0
	velocity.y = -50 
	$AnimatedSprite2D.play("dead")
	await get_tree().create_timer(0.6).timeout
	self.queue_free() 

func boxClear():
	$hitDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$hitbox.call_deferred("set", "disabled", true)

func damage(value):
	HP -= value
	velocity.x = SPEED * dirX * -1
	velocity.y = -80
	$hitDetect.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	$hitDetect.call_deferred("set", "disabled", false)
