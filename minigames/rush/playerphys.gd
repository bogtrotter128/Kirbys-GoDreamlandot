extends CharacterBody2D

@onready var main = $"../.."

var frenval = 0
var xpos = -160
var JUMP
var LEFT
var RIGHT

var jumpcount = 1
var canhurt = true
var jump_power_initial = -150
var jump_power = 0
var JUMP_VELOCITY_STEP = 0.1
var jump_timer = 0.0
var jump_time_max = 0.3
var is_jumping = false

var sfx = {
	"collect": preload("res://kirbySprites/sfx/health.wav"),
	"jump1" : preload("res://kirbySprites/sfx/jump.wav"),
	"jump2" : preload("res://kirbySprites/sfx/jump 2.wav"),
	"hurt" : preload("res://kirbySprites/sfx/hurt.wav")
}

func _ready():
	if name == "player1":
		JUMP = "jump"
		LEFT = "left"
		RIGHT = "right"
		frenval = GameUtils.FRENVAL
	else:
		JUMP = "P2jump"
		LEFT = "P2left"
		RIGHT = "P2right"
		frenval = GameUtils.FRENVALP2
	$AnimatedSprite2D.play(str(frenval) + " run")

func _input(event):
	# Handle long Jump stop.
	$AnimatedSprite2D.speed_scale = main.VELOCITY / 2
	if event.is_action_released(JUMP) && is_jumping:
		jump_timer = jump_time_max

func _process(_delta):
	# Handle long Jump.
	if Input.is_action_pressed(JUMP) and is_jumping == false:
		jump()
	if Input.is_action_pressed(JUMP) && is_jumping == true && jump_timer < jump_time_max:
		jump_power -= JUMP_VELOCITY_STEP
		apply_jump_force(jump_power)
#	if Input.is_action_pressed(LEFT) or Input.is_action_pressed(RIGHT):
	var direction = Input.get_axis(LEFT, RIGHT)
	if position.x == xpos:
		xpos += 1 * direction
		xpos = -150 if xpos < -150 else xpos
		xpos = -50 if xpos > -50 else xpos

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, 200, 10)
		jump_timer += delta
	position.x = move_toward(position.x, xpos, 2.5)
	move_and_slide()

func jump():
	if is_jumping == false:
		is_jumping = true
		$AnimatedSprite2D.play(str(frenval) + " jump")
		jumpsfx()
		velocity.y = jump_power_initial
		jump_timer = 0.0
		apply_jump_force(jump_power_initial)
		jump_power = jump_power_initial

func jumpsfx():
	jumpcount += 1
	var jumpcountS = 1 if jumpcount % 2 == 0 else 2
	var jumpsfxscore = "jump" + str(jumpcountS)
	Sfxhandler.play_sfx(sfx[jumpsfxscore],get_parent())

func apply_jump_force(power):
	velocity.y = power

func hurt():
	$AnimatedSprite2D.speed_scale = main.VELOCITY / 2
	$AnimatedSprite2D.play(str(frenval) + " hurt")
	Sfxhandler.play_sfx(sfx["hurt"],get_parent())
	velocity.y = jump_power_initial
	main.VELOCITY = main.VELOCITY - 1.25 if main.VELOCITY > main.lowestVELOCITY + 1.25 else main.VELOCITY
	main.rushscore -= 100
	main.rushscore = 0 if main.rushscore <= 0 else main.rushscore
	$"../../timer UI".updatescore(main.rushscore)

func _on_area_2d_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("tiles"):
		is_jumping = false
		jump_timer = 0.0
		$AnimatedSprite2D.play(str(frenval) + " run")
	if body.is_in_group("collectable"):
		main.rushscore += body.score
		$"../../timer UI".updatescore(main.rushscore)
		body.queue_free()
		Sfxhandler.play_sfx(sfx["collect"],get_parent())
	if body.is_in_group("hazard") && canhurt == true:
		canhurt = false
		hurt()
		#if endless mode true ; endgame and save scores
