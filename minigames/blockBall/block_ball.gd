extends Node2D

@onready var pointnotif = preload("res://minigames/blockBall/pointcounterspawn.tscn")
@onready var ball1 = preload("res://minigames/blockBall/ball.tscn")
@onready var ball2 = preload("res://minigames/blockBall/p_2_ball.tscn")
var paused = false
@onready var pause = $CanvasLayer/general_pause_menu
@onready var levels = {
#	11: preload(""),
#	12: preload(""),
#	13: preload(""),
#	14: preload(""),
#	15: preload(""),
#	21: preload(""),
#	22: preload(""),
#	23: preload(""),
#	24: preload(""),
#	25: preload(""),
#	31: preload(""),
#	32: preload(""),
#	33: preload(""),
#	34: preload(""),
#	35: preload("")
}

@export var xbounds = [-116,116]
@export var ybounds = [-30,38]
var ballscore = 3
var ballcount = 0
var bonusscore = 0
var stagescore = 11 #set by level nodes on load-in
var score = 0

var ball1pos = Vector2.ZERO
var ball2pos = Vector2.ZERO

func _ready():
	scorecount(GameUtils.blockballstagescore[0])
	$CanvasLayer/UI.updateUI(ballscore)

func _input(_event):
	if Input.is_action_just_pressed("start"):
		pauseMenu()

func roomload(lvlscore):
	var room = levels[lvlscore].instantiate()
	ballcount = 0
	get_tree().call_group("paddle", "new_ball")
	get_tree().call_group("ball","queue_free")
	$room.queue_free()
	#do a screen transition
	call_deferred("add_child",room)

func updatepaddles(Ypaddlecheck):
	if Ypaddlecheck == false:
		$Ypaddle1.hide()
		$Ypaddle2.hide()
		$Ypaddle1.call_deferred("set","disabled",true)
		$Ypaddle2.call_deferred("set","disabled",true)
	else:
		$Ypaddle1.show()
		$Ypaddle2.show()
		$Ypaddle1.call_deferred("set","disabled",false)
		$Ypaddle2.call_deferred("set","disabled",false)

func scorecount(lvlscore):
	if lvlscore < 13:
		scoreset(0)
	if lvlscore == 14 or lvlscore == 15:
		scoreset(1)
	if lvlscore == 21 or lvlscore == 22 or lvlscore == 23:
		scoreset(2)
	if lvlscore == 24 or lvlscore == 25:
		scoreset(3)
	if lvlscore == 31 or lvlscore == 32 or lvlscore == 33:
		scoreset(4)
	if lvlscore == 34 or lvlscore == 35:
		scoreset(5)

func scoreset(place):
	if score >= GameUtils.blockballhiscore[place]:
		GameUtils.blockballhiscore[place] = score

func pauseMenu():
	if paused:
		pause.set_process_input(false)
		pause.hide()
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false
	else:
		pause.set_process_input(true)
		pause.show()
		get_tree().paused = true
	pause.selected = 1
	pause.movestart()
	paused = !paused

func secondplayerrules():
	$player2paddle.playernum = 2 if GameUtils.SECONDPLAYER == true else 1
	$Ypaddle2.playernum = 2 if GameUtils.SECONDPLAYER == true else 1
	$player2paddle.MAINPADDLE = GameUtils.SECONDPLAYER
	$player2paddle.new_ball()
	$player2paddle.start = !GameUtils.SECONDPLAYER
	$player2paddle.pinput()
	$Ypaddle2.pinput()
	if GameUtils.SECONDPLAYER == false:
		ballcount /= 2
		get_tree().call_group("ball2","loseball")
		$player2paddle.position.x = $player1paddle.position.x
		$player2paddle.pos.x = $player1paddle.pos.x
		$Ypaddle2.position.y = $Ypaddle1.position.y
		$Ypaddle2.pos.y = $Ypaddle1.pos.y

func pointspawn(pointcount,coords):
	score += pointcount
	$CanvasLayer/UI.updateUI(ballscore)
	var notif = pointnotif.instantiate()
	notif.position = coords
	notif.score = pointcount
	call_deferred("add_child", notif)

func updateUI():
	$CanvasLayer/UI.updateUI(ballscore)

func lose():
	print(ballcount)
	ballcount -= 1
	ballscore -= 1
	$CanvasLayer/UI.updateUI(ballscore)
	if ballscore < 0:
		gameover()
	else:
		get_tree().call_group("paddle", "new_ball")

func gameover():
	var stagemain = int((stagescore/10)%10)
	var stagesub = int(stagescore%10)
	if stagesub < 4: #normal stages 1-3
		print(stagemain + 1)
		roomload(stagemain + 1)
	else: #boss stages 4-5
		print(stagemain + 4)
		roomload(stagemain + 4)

func specialitem(itemval):
	if itemval == 3:
		crash()
	if itemval == 4:
		abilityChanger()
	if itemval == 5:
		flip()
	if itemval == 6:
		duplicateball()

func crash():
	pass #destroys unbreakable blocks

func abilityChanger():
	pass

func flip():
	pass


func duplicateball():
	var ball = ball1.instantiate()
	ball.position = ball1pos
	ballcount += 1
	$".".add_child(ball)
	if GameUtils.SECONDPLAYER == true:
		var ball2s = ball2.instantiate()
		ball2s.position = ball2pos
		ballcount += 1
		$".".add_child(ball2s)
