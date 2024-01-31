extends CharacterBody2D

@export var frenval = 1
var check1 = false
var check2 = false
var targetcheck = true
var cancheck = false
func _ready():
	$AnimatedSprite2D.play(str(frenval))
	if GameUtils.FRENVAL == frenval or GameUtils.FRENVALP2 == frenval:
		self.queue_free() #this removes any duplicate animal friends
	await get_tree().create_timer(0.3).timeout
	cancheck = true

func _input(_event):
	if Input.is_action_just_pressed("c") && check1 == true && cancheck == true:
		cancheck = false
		$playerdect/CollisionShape2D.call_deferred("set","disabled",true)
		p1.frenval = frenval #sets the player's frenval equal to idlefrend's so that they summon teh correct friend
		p1.get_parent().summonfren(p1,frenval) #summons friend with func in the player script
		p1.queue_free()
		self.queue_free()
	if Input.is_action_just_pressed("P2c") && check2 == true && cancheck == true:
		cancheck = false
		$playerdect/CollisionShape2D.call_deferred("set","disabled",true)
		p2.frenval = frenval
		p2.get_parent().summonfren(p2,frenval)
		p2.queue_free()
		self.queue_free() 

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
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, 200, 7)
	move_and_slide()
var p1
var p2
func _on_playerdect_body_entered(body):
	if body.name == "Player1": # animal friend players cant activate these. maybe good?
		check1 = true
		p1 = body
	if body.name == "Player2":
		check2 = true
		p2 = body

func _on_playerdect_body_exited(body):
	if body.name == "Player1":
		check1 = false
	if body.name == "Player2":
		check2 = false

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
