extends CharacterBody2D

const SPEED = 40
@export var dirX = 1
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0

@export var HP = 2
@export var hide = true
var chase = false
var dropfall = false
var copyAbilityScore = 0

func _ready():
	if hide == true:
		$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	if hide == false:
		$AnimatedSprite2D.play("default")

func _process(_delta):
	if chase == true:
		$AnimatedSprite2D.play("default")
		targetmath()
	if dropfall == true:
		$AnimatedSprite2D.play("fall")
	if hide == true:
		$AnimatedSprite2D.play("idle")
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if HP <= 0:
		death()

func _physics_process(_delta):
	if chase == false && dropfall == false && hide == false:
		flight()
	if chase == true:
		follow(chaseX)
	if dropfall == true or hide == true:
		fall()
	
	
	if WINDFORCEX > 0 && velocity.x < WINDFORCEX or WINDFORCEX < 0 && velocity.x > WINDFORCEX:
		velocity.x = move_toward(velocity.x, velocity.x + WINDFORCEX, 5)
	if WINDFORCEY != 0:
		velocity.y = move_toward(velocity.y, WINDFORCEY, 16)
	move_and_slide()

func flight():
	velocity.x = move_toward(velocity.x,SPEED * dirX, 4)

func fall():
	velocity.x = move_toward(velocity.x,0, 4)
	if not is_on_floor():
		velocity.y = move_toward(velocity.y,200, 7)
	if is_on_floor():
		hide = true
		await  get_tree().create_timer(0.7).timeout
		dropfall = false
		$hideDetect/CollisionShape2D.call_deferred("set", "disabled", false)
		$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		chase = false
		dropfall = true

func _on_hide_detect_body_entered(body):
	if body.is_in_group("player"):
		hide = false
		chase = true
		$hideDetect/CollisionShape2D.call_deferred("set", "disabled", true)
		$playerDetect/CollisionShape2D.call_deferred("set", "disabled", false)

var chaseX = 1
func follow(chasedirX):
	velocity.x = move_toward(velocity.x,SPEED * chasedirX, 4)
	if global_position.y > targetY - 70: # the < sign is flipped cuz up is negative. so >
		velocity.y = move_toward(velocity.y,SPEED * -1, 4)
	elif global_position.y < targetY - 70:
		velocity.y = move_toward(velocity.y,0, 4)

var tempos
var tempos2
var targetY = global_position.y
func targetmath():
	tempos = global_position.x - GameUtils.posX
	tempos2 = global_position.x - GameUtils.posXP2
	if tempos < 0:
		tempos *= -1
	if tempos2 < 0:
		tempos2 *= -1
	
	if tempos < tempos2:
		targetY = GameUtils.posY
		if GameUtils.posX < global_position.x:
			chaseX = -1
		elif GameUtils.posX > global_position.x:
			chaseX =  1
	elif tempos > tempos2:
		targetY = GameUtils.posYP2
		if GameUtils.posXP2 < global_position.x:
			chaseX = -1
		elif GameUtils.posXP2 > global_position.x:
			chaseX =  1

func _on_fliptimer_timeout():
	if chase == false:
		dirX *= -1


func _on_walldetect_x_body_entered(body):
	if body.name == "maintiles" && chase == false:
		dirX *= -1
		$walldetectX/CollisionShape2D.call_deferred("set", "disabled", true)
		await get_tree().create_timer(0.3).timeout
		$walldetectX/CollisionShape2D.call_deferred("set", "disabled", false)


func death():
	boxClear()
	velocity.x = 0
	velocity.y = -50 
	self.queue_free() 

func boxClear():
	$hitDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$playerDetect/CollisionShape2D.call_deferred("set", "disabled", true)
	$hitbox.call_deferred("set", "disabled", true)

func damage(value):
	$AnimatedSprite2D.play("hurt")
	HP -= value
	velocity.x = SPEED * dirX * -1
	velocity.y = -80
	$hitDetect.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	$hitDetect.call_deferred("set", "disabled", false)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.play("default")

