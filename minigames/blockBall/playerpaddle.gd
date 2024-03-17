extends StaticBody2D

@onready var main = $".."
@onready var ball1 = preload("res://minigames/blockBall/ball.tscn")
@onready var ball2 = preload("res://minigames/blockBall/p_2_ball.tscn")
var ballangle : Vector2
@export var MAINPADDLE = true #this determins if this paddle summons a ball
@export var xdircheck = true
@export var playernum = 1 # 1 or 2
var start = false
var pos = Vector2.ZERO
#var rotlist = [90, 45, 23, 45, 90, -45, -23, -45]
var rotlist = [Vector2(0,-1),Vector2(1,-1),Vector2(1.9,-0.8),Vector2(1,-1),Vector2(0,-1),Vector2(-1,-1),Vector2(-0.8,-1.8),Vector2(-1,-1),]
var rotplace = 0
var JUMP
var A
var UP
var DOWN
var LEFT
var RIGHT

@onready var sfx = {
	"catch" : preload("res://kirbySprites/sfx/land.wav"),
	"launch" : preload("res://kirbySprites/sfx/spit.wav"),
	"throwball" : preload("res://kirbySprites/sfx/fly-spit.wav"),
}

func _ready():
	pinput()
	if MAINPADDLE == true:
		start = false
		main.ballcount += 1
	else:
		start = true
		$ballaimsprite.hide()

func new_ball():
	if MAINPADDLE == true:
		start = false
		main.ballcount += 1
		rotplace = 0
		$ballaimsprite.show()
		$ballaimsprite.play("aim"+str(playernum))
	else:
		$ballaimsprite.hide()

func pinput():
	if playernum == 1:
		JUMP = "jump"
		A = "a"
		LEFT = "left"
		RIGHT = "right"
		UP = "up"
		DOWN = "down"
	else:
		JUMP = "P2jump"
		A = "P2a"
		LEFT = "P2left"
		RIGHT = "P2right"
		UP = "P2up"
		DOWN = "P2down"
	$paddlesprite.play("default"+str(playernum))
	$ballaimsprite.play("aim"+str(playernum))

func _process(_delta):
	if xdircheck == true:
		xdir()
	if xdircheck == false:
		ydir()
	
func xdir():
	var direction = Input.get_axis(LEFT, RIGHT)
	if position.x == pos.x:
		pos.x += 5 * direction
		pos.x = main.xbounds[0] if pos.x < main.xbounds[0] else pos.x
		pos.x = main.xbounds[1] if pos.x > main.xbounds[1] else pos.x
	position.x = move_toward(position.x, pos.x, 3)
func ydir():
	var direction = Input.get_axis(UP, DOWN)
	if position.y == pos.y:
		pos.y += 5 * direction
		pos.y = main.ybounds[0] if pos.y < main.ybounds[0] else pos.y
		pos.y = main.ybounds[1] if pos.y > main.ybounds[1] else pos.y
	position.y = move_toward(position.y,pos.y,3)

func _input(_event):
	if Input.is_action_just_pressed(JUMP):
		if start == true:
			launch()
		else:
			throwball()
	if Input.is_action_just_pressed(A):
		print("ability")
func _on_ballaimsprite_frame_changed():
	if start == false:
		updateangle()
func updateangle():
	rotplace += 1
	rotplace = 0 if rotplace > 7 else rotplace
	ballangle = rotlist[rotplace]

func throwball():
	start = true
	var ball = ball1.instantiate() if playernum == 1 else ball2.instantiate()
	ball.velocity = ballangle * 7 if playernum == 1 else ballangle * -7
	ball.position = Vector2(position.x,position.y - 5) if playernum == 1 else Vector2(position.x,position.y + 5)
	main.add_child(ball)
	$ballaimsprite.hide()
	$ballaimsprite.stop()
	Sfxhandler.play_sfx(sfx["throwball"],main)

func launch():
	$paddlesprite.play("hit"+str(playernum))
	await get_tree().create_timer(0.05).timeout
	$Area2D/CollisionShape2D.call_deferred("set","disabled",false)
	await get_tree().create_timer(0.3).timeout
	$Area2D/CollisionShape2D.call_deferred("set","disabled",true)
	if $paddlesprite.animation != ("launch"+str(playernum)):
		$paddlesprite.play("default"+str(playernum))

func catch():
	Sfxhandler.play_sfx(sfx["catch"],main)
	if $paddlesprite.animation != ("launch"+str(playernum)):
		$paddlesprite.play("hit"+str(playernum))
		await get_tree().create_timer(0.4).timeout
		$paddlesprite.play("default"+str(playernum))

func _on_area_2d_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("ball"):
		body.powerup()
		Sfxhandler.play_sfx(sfx["launch"],main)
		$paddlesprite.play("launch"+str(playernum))
		await $paddlesprite.animation_finished
		$paddlesprite.play("default"+str(playernum))

func get_width():
	return $CollisionShape2D.shape.get_rect().size.x
