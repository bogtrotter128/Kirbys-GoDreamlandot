extends Node2D

@onready var pointnotif = preload("res://minigames/blockBall/pointcounterspawn.tscn")
@onready var ball1 = preload("res://minigames/blockBall/ball.tscn")
var paused = false
@onready var pause = $"UI elements/general_pause_menu"
@onready var screenani = $"UI elements/screentransition/screen transition/AnimationPlayer"
@onready var levels = {
	11: preload("res://minigames/blockBall/rooms/room11.tscn"),
	12: preload("res://minigames/blockBall/rooms/room12.tscn"),
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

var xbounds = [-84,84]
var ybounds = [-30,38]
var ballscore = 99
var ballcountP1 = 0
var ballcountP2 = 0

var blockcount = 0
var blockgoal = 0
var bonusscore = 0
var stagescore = 11 #set by level nodes on load-in
var score = 0

var ball1pos = Vector2.ZERO
var ball2pos = Vector2.ZERO

var canswap = true

func _ready():
	black()
	scorecount(stagescore)
	$"UI elements/UI".updateUI(ballscore)
	roomload(stagescore)

func _physics_process(_delta):
	if blockcount == blockgoal && blockgoal > 1 && canswap == true:
		canswap = false
		nextlevel()

func _input(_event):
	if Input.is_action_just_pressed("start"):
		pauseMenu()
	#if Input.is_action_just_pressed("a"): #debug tool
		#nextlevel()

func roomload(lvlscore):
	blockcount = 0
	bonusscore = 0
	var room = levels[lvlscore].instantiate()
	ballcountP1 = 0
	ballcountP2 = 0
	get_tree().call_group("paddle", "new_ball")
	get_tree().call_group("ball","queue_free")
	get_tree().call_group("room","queue_free")
	call_deferred("add_child",room)

func updatepaddles(Ypaddlecheck):
	if Ypaddlecheck == false:
		$Ypaddle1.hide()
		$Ypaddle2.hide()
		$Ypaddle1/CollisionShape2D.call_deferred("set","disabled",true)
		$Ypaddle2/CollisionShape2D.call_deferred("set","disabled",true)
	else:
		$Ypaddle1.show()
		$Ypaddle2.show()
		$Ypaddle1/CollisionShape2D.call_deferred("set","disabled",false)
		$Ypaddle2/CollisionShape2D.call_deferred("set","disabled",false)

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
		ballcountP2 = 0
		get_tree().call_group("ball2","loseball")
		$player2paddle.position.x = $player1paddle.position.x
		$player2paddle.pos.x = $player1paddle.pos.x
		$Ypaddle2.position.y = $Ypaddle1.position.y
		$Ypaddle2.pos.y = $Ypaddle1.pos.y
		lose() #for checking if p1 needs respawn

func pointspawn(pointcount,coords):
	score += pointcount
	$"UI elements/UI".updateUI(ballscore)
	var notif = pointnotif.instantiate()
	notif.position = coords
	notif.score = pointcount
	call_deferred("add_child", notif)

func updateUI():
	$"UI elements/UI".updateUI(ballscore)

func lose():
	if ballcountP1 == 0 && ballcountP2 == 0:
		ballscore -= 1
		updateUI()
		if ballscore < 0:
			gameover()
		else:
			get_tree().call_group("paddle", "new_ball")

func gameover():
	ballscore = 3
	scorecount(stagescore)
	score = 0
	updateUI()
	resetpaddlelocation()
	@warning_ignore("integer_division")
	var stagemain = int((stagescore/10)%10)
	var stagesub = int(stagescore%10)
	if stagesub < 4: #normal stages 1-3
		print((stagemain*10) + 1)
		roomload((stagemain*10) + 1)
	else: #boss stages 4-5
		print((stagemain*10) + 4)
		roomload((stagemain*10) + 4)

func nextlevel():
	scorecount(stagescore)
	updateUI()
	resetpaddlelocation()
	#screen transition
	fade_to_black()
	if int(stagescore%10) < 5:
		score = 0 if int(stagescore%10) > 3 else score
		await get_tree().create_timer(0.5).timeout
		roomload(stagescore + 1)
		canswap = false
	else: #change this to the main blockball menu
		get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")

func black():
	screenani.play("black")
func fade_to_black():
	screenani.play("fade_to_black")
func fade_from_black():
	screenani.play("fade_from_black")

func resetpaddlelocation():
	$player1paddle.position.x = 0
	$player1paddle.pos.x = 0
	$player2paddle.position.x = 0
	$player2paddle.pos.x = 0
	$Ypaddle1.position.y = 8
	$Ypaddle1.pos.y = 8
	$Ypaddle2.position.y = 8
	$Ypaddle2.pos.y = 8

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
	get_tree().call_group("unbreakablock", "destroy")

func abilityChanger():
	pass
	#probably put this in the ball's code for specific player input
	#pause ball velocity
	#shift through abilities
	#wait for player input
	#unpause

func flip():
	get_tree().call_group("block","flip")

func duplicateball():
	var ball = ball1.instantiate()
	ball.position = ball1pos
	ballcountP1 += 1
	$".".add_child(ball)
	if GameUtils.SECONDPLAYER == true:
		var ball2s = ball1.instantiate()
		ball2s.position = ball2pos
		ball2s.playerballval = 2
		ballcountP2 += 1
		$".".add_child(ball2s)
