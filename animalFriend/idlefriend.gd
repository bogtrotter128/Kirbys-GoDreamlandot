extends CharacterBody2D

@export var frenval = 1
var swim = false
var targetcheck = true
func _ready():
	$AnimatedSprite2D.play(str(frenval))
	if GameUtils.FRENVAL == frenval or GameUtils.FRENVALP2 == frenval:
		self.queue_free() #this removes any duplicate animal friends
	#await get_tree().create_timer(0.3).timeout
	#cancheck = true

func _process(_delta):
	if targetcheck == true:
		targetmath()
	
	if GameUtils.FRENVAL > 0 && targetcheck == true:
		$AnimatedSprite2D.play(str(frenval)+"shock")
		await get_tree().create_timer(0.4).timeout
		$AnimatedSprite2D.play(str(frenval)+"sad")
		targetcheck = false
	if GameUtils.FRENVAL == 0 && targetcheck == false:
		$AnimatedSprite2D.play(str(frenval))
		targetcheck = true

func _physics_process(_delta):
	if not is_on_floor() && swim == false:
		velocity.y = move_toward(velocity.y, 200, 7)
	if swim == true:
		velocity.y = move_toward(velocity.y, 10, 0.5)
	move_and_slide()
func _on_playerdect_body_entered(body):
	if body.is_in_group("water"):
		swim = true
		velocity.y = velocity.y /2

func _on_playerdect_body_exited(body):
	if body.is_in_group("water"):
		swim = false

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
		if GameUtils.posX < global_position.x && $AnimatedSprite2D.flip_h == false:
			fliptrue()
		elif GameUtils.posX > global_position.x && $AnimatedSprite2D.flip_h == true:
			flipfalse()
	elif tempos > tempos2:
		if GameUtils.posXP2 < global_position.x && $AnimatedSprite2D.flip_h == false:
			fliptrue()
		elif GameUtils.posXP2 > global_position.x && $AnimatedSprite2D.flip_h == true:
			flipfalse()

func fliptrue():
	$AnimatedSprite2D.play(str(frenval) + "turn")
	$AnimatedSprite2D.flip_h = true
	await get_tree().create_timer(0.15).timeout
	$AnimatedSprite2D.play(str(frenval))

func flipfalse():
	$AnimatedSprite2D.play(str(frenval) + "turn")
	$AnimatedSprite2D.flip_h = false
	await get_tree().create_timer(0.15).timeout
	$AnimatedSprite2D.play(str(frenval))

func _on_visible_on_screen_notifier_2d_screen_entered():
	targetcheck = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	targetcheck = false
