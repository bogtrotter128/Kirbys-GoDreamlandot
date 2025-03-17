extends Node2D
var countup = true
var score = 0
var P2score = 0
var time = 0.0
var minutes = 0
var seconds = 0
var msec = 0

@onready var HUD = $CanvasLayer/HUD
@onready var p1scoredisplay = $CanvasLayer/score
@onready var p2scoredisplay = $CanvasLayer/scorep2

@onready var timerHUDP1 = preload("res://kirbySprites/UI/timer/timerHUD.png")
@onready var timerHUDP2 = preload("res://kirbySprites/UI/timer/timerHUDP2.png") 

func _ready():
	set_process(false)
	setplayerscorecounters()

func setplayerscorecounters():
	if GameUtils.SECONDPLAYER == true: #if in 2p, changes the HUD to the 2p HUD
		HUD.texture = timerHUDP2
		p1scoredisplay.position = Vector2(170,9)
		p2scoredisplay.show()
	else:
		HUD.texture = timerHUDP1
		p1scoredisplay.position = Vector2(173,23)
		p2scoredisplay.hide()

func start_timer(timev, countupcheck):
	time = timev # the starting time
	countup = countupcheck #true; count up. false; count down
	set_process(true)

func stop_timer():
	set_process(false)

func _process(delta):
	time += delta if countup == true else delta * -1
	msec = int((fmod(time, 1) * 1000) * 1)
	seconds = int(fmod(time, 60))
	minutes = int(fmod(time,3600) / 60)
	if time > 0.0:
		updateclock()
	else:
		msec = 0
		seconds = 0
		minutes = 0
		updateclock()
		set_process(false)

func updateclock():
	@warning_ignore("integer_division")
	var mins = [int((minutes/10)%10),int(minutes%10)]
	@warning_ignore("integer_division")
	var secs = [int((seconds/10)%10),int(seconds%10)]
	@warning_ignore("integer_division")
	var msecs = [int((msec/100)%10),int((msec/10)%10),int(msec%10)]
	for i in $CanvasLayer/minutes.get_child_count():
		$CanvasLayer/minutes.get_child(i).frame = mins[i]
	for i in $CanvasLayer/sec.get_child_count():
		$CanvasLayer/sec.get_child(i).frame = secs[i]
	for i in $CanvasLayer/msec.get_child_count():
		$CanvasLayer/msec.get_child(i).frame = msecs[i]

func updatescore(num):
	updatedisplayscore(num,p1scoredisplay)
	score = num if num <= 99999 else score

func updatescoreP2(num):
	updatedisplayscore(num,p2scoredisplay)
	P2score = num if num <= 99999 else P2score

func updatedisplayscore(num,displayscore):
	if num <= 99999:
		var scores = [int((score/100000)%10),int((score/10000)%10),int((score/1000)%10),int((score/100)%10),int((score/10)%10),int(score%10)]
		for i in displayscore.get_child_count():
			displayscore.get_child(i).frame = scores[i] if scores[i] >= 0 else 0
	else:
		for i in displayscore.get_child_count():
			displayscore.get_child(i).frame = 9
