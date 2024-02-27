extends CharacterBody2D

var dir = 1
var SPEED = 40
var JUMP = -150
var GRAVITY = 200
var chase = false

@export var swim = false
@export var copyAbilityScore = 0
@export var HP = 4
var deathpoof = preload("res://enemy scenes/deathpoof/deathsprite.tscn")
var screennotif = preload("res://enemy scenes/enemy_visible_on_screen_notifier_2d.tscn")
func _ready():
	var screennotifer = screennotif.instantiate()
	call_deferred("add_child", screennotifer)

func _process(_delta):
	if HP <= 0:
		death()
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, GRAVITY, 7)
	if chase == false:
		idle()
	if chase == true:
		targetmath()
		follow(chaseX,chaseY)
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	move_and_slide()

func idle():
	velocity.x = move_toward(velocity.x,SPEED * dir, 4)

var chaseX = 1
var chaseY = 1
func follow(chasedirX,chasedirY):
	velocity.x = move_toward(velocity.x,SPEED * chasedirX, 4)
	if chasedirY == -1 && is_on_floor():
		jump()

func jump():
	await get_tree().create_timer(0.2).timeout
	velocity.y = JUMP

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		chase = true
	if body.is_in_group("player"):
		$runtimertimeout.stop()
	body = null
func _on_player_detect_body_exited(body):
	if body.is_in_group("player") && HP > 0:
		await get_tree().create_timer(0.1).timeout
		$runtimertimeout.start()

var tempos
var tempos2
var targetX = 0
var targetY = 0

func targetmath():
	tempos = abs(global_position.x - GameUtils.posX)
	tempos2 = abs(global_position.x - GameUtils.posXP2)
	
	targetX = GameUtils.posX if tempos < tempos2 else GameUtils.posXP2
	targetY = GameUtils.posY + 8 if tempos < tempos2 else GameUtils.posYP2 + 8

	chaseX = -1 if targetX < global_position.x else 1
	chaseY = -1 if targetY < global_position.x else 1

func _on_turn_timer_timeout():
	dir *= -1

func _on_runtimertimeout_timeout():
	chase = false

func death():
	velocity.x = 0
	velocity.y = -50 
	var poof = deathpoof.instantiate()
	call_deferred("add_sibling", poof)
	poof.global_transform = global_transform
	self.queue_free()

func damage(value):
	$AnimatedSprite2D.play("hurt")
	velocity.x = SPEED * dir * -1
	velocity.y = -150
	HP -= value
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.play("default")
