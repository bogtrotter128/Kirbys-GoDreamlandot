extends Control

@onready var score1 = $scoredisplay/score1
@onready var score2 = $scoredisplay/score2
@onready var time1 = $scoredisplay/time1
@onready var time2 = $scoredisplay/time2

var sfx = {
	"pause" : preload("res://kirbySprites/sfx/pause.wav"),
	"menuselect" : preload("res://kirbySprites/sfx/menu-select.wav"),
	"cantselect" : preload("res://kirbySprites/sfx/toss.wav"),
	"back" : preload("res://kirbySprites/sfx/enter-door.wav")
}

var hudspritelist = {
	"hudplain" : preload("res://kirbySprites/UI/minigames/select screen.png"),
	"hudscores": preload("res://kirbySprites/UI/minigames/select screen compscores.png"),
	"hudtimers": preload("res://kirbySprites/UI/minigames/select screen time.png"),
	"hudarena" : preload("res://kirbySprites/UI/minigames/select screen arena.png")
}
var stagevallist = []
var unlockedstages = []
var poslist = []
var selected = 0
var SELECTEDVAL = 0
var canselect = true


func _ready():
	updateHUD(GameUtils.minigameval)
	updatelevels()
	updateselectvals(GameUtils.minigameval)
	movestar()
	updatetitle()

func _input(_event):
	if canselect == true:
		if Input.is_action_pressed("up") or Input.is_action_pressed("P2up"):
			selected = selected - 1 if selected > 0 else (stagevallist.size() - 1)
			movestar()
		if Input.is_action_pressed("down") or Input.is_action_pressed("P2down"):
			selected = selected + 1 if selected < (stagevallist.size() - 1) else 0
			movestar()
		if GameUtils.minigameval != 6:
			if Input.is_action_pressed("left") or Input.is_action_pressed("P2left"):
				if selected == 6 or selected == 7:
					selected = selected - 1 if selected > 0 else (stagevallist.size() - 1)
				if selected == 1:
					selected = 5
				elif selected != 6 && selected != 7:
					selected = selected - 2 if selected > 0 else selected + 4
				movestar()
			if Input.is_action_pressed("right") or Input.is_action_pressed("P2right"):
				if selected == 6 or selected == 7:
					selected = selected + 1 if selected < (stagevallist.size() - 1) else 0
				elif selected != 6 && selected != 7:
					selected = selected + 2 if selected < (stagevallist.size() - 4) else selected - 4
				movestar()
		
		if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("P2a"):
			select(stagevallist[selected])

func movestar():
	canselect = false
	displayscoredisplay()
	Sfxhandler.play_sfx(sfx["menuselect"],self)
	SELECTEDVAL = stagevallist[selected]
	print(SELECTEDVAL)
	$starselecter.position = poslist[selected]
	if SELECTEDVAL == 88:
		$starselecter2.show()
	else:
		$starselecter2.hide()

func _on_canselecttimer_timeout():
	canselect = true

func select(mgselect):
	if mgselect == 0:
		print("return to popstar")
		get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")
	#lets you enter stages 1-1 and 1-2
	elif mgselect == 11 or mgselect == 12:
		enter()
		print("startminigame")
	#checks if not arena, then if its not lvl 1-1/1-2 and then it checks if unlocked in unlockedstages
	elif GameUtils.minigameval != 6 && mgselect > 12 && unlockedstages[mgselect - 2] == true:
		enter()
		print("startmini unlocked gamelvl")
	#checks if you can enter the true arena
	elif GameUtils.minigameval == 6 && mgselect == 1 && GameUtils.truearenaunlocked == true:
		print("entering the TRUE ARENA")
		enter()
	
	else: #cant enter
		cantenter()
	
func enter():
	pass

func cantenter():
	print("cant enter")
	Sfxhandler.play_sfx(sfx["cantselect"],self)


func updatelevels():
	for i in unlockedstages.size():
		$levelunlocks.get_child(i).visible = unlockedstages[i]
		print(unlockedstages[i])

func updatetitle():
	if GameUtils.minigameval < 5:
		$title.frame = GameUtils.minigameval - 1

func updateHUD(val):
	if val == 1:
		gofish()
	elif val == 2:
		rush()
	elif val == 3:
		egggame()
	elif val == 4:
		blockball()
	elif val == 5:
		gourmetrace()
	elif val == 6:
		arena()
	else:
		print("no proper minigame selected")

func updateselectvals(val):
	if val <= 5:
		setstagevals8()
	else:
		setstagevals3()
func gofish():
	setHUD("hudscores")
	unlockedstages = GameUtils.gofishunlock
	displaytimers(false)
	displayscores(true)

func rush():
	unlockedstages = GameUtils.rushunlock

func egggame():
	pass

func blockball():
	unlockedstages = GameUtils.blockballunlock

func gourmetrace():
	setHUD("hudtimers")
	unlockedstages = GameUtils.gourmetunlock

func arena():
	setHUD("hudarena")
	unlockedstages = [false,false,false,false,false]

	$scoredisplay/score2.hide()
	$scoredisplay/time1.hide()
	$title.hide()
	$starselecter2.position = Vector2(215,167)
	if GameUtils.truearenaunlocked == true:
		$truearenasprite.show()

func setHUD(hudname):
	$hudsprite.texture = hudspritelist[hudname]

func displayscores(boole):
	$scoredisplay/score1.visible = boole
	$scoredisplay/score2.visible = boole
func displaytimers(boole):
	$scoredisplay/time1.visible = boole
	$scoredisplay/time2.visible = boole

func setstagevals8():
	stagevallist = [11,12,21,22,31,32,88,0] #88 is the special endless/prple one. 0 is the BACK option
	poslist = [Vector2(64,146),Vector2(64,169),Vector2(135,146),Vector2(135,169),
			Vector2(205,146),Vector2(205,169),Vector2(74,192),Vector2(198,192)]

func setstagevals3(): #used for the unqiue layout of the arena menu
	stagevallist = [11,88,0]
	poslist = [Vector2(108,144),Vector2(108,168),Vector2(136,192)]

func displayscoredisplay():
	var scorelist1 = [GameUtils.gofishscore1,GameUtils.rushhiscore1,GameUtils.egggamescore1,GameUtils.blockballhiscore,GameUtils.gourmetracetime1,GameUtils.arenascore]
	var scorelist2 = [GameUtils.gofishscore2,GameUtils.rushhiscore2,GameUtils.egggamescore2,GameUtils.blockballhiscore,GameUtils.gourmetracetime2,GameUtils.arenatime]
	if selected != 7 && GameUtils.minigameval != 6 or GameUtils.minigameval == 6 && selected != 2:
		if score1.visible == true:
			updatescore(scorelist1[GameUtils.minigameval-1][selected],score1)
			print(scorelist1[GameUtils.minigameval-1][selected])
		elif time1.visible == true:
			updatetime(scorelist1[GameUtils.minigameval-1][selected],time1)
			print(scorelist1[GameUtils.minigameval-1][selected])
		if score2.visible == true:
			updatescore(scorelist2[GameUtils.minigameval-1][selected],score2)
		elif time2.visible == true:
			updatetime(scorelist2[GameUtils.minigameval-1][selected],time2)
	elif selected == 7 && GameUtils.minigameval != 6 or GameUtils.minigameval == 6 && selected == 2:
		updatescore(0,score1)
		updatetime(0,time1)
		updatescore(0,score2)
		updatetime(0,time2)

func updatetime(time,node):
	var msec = int((fmod(time, 1) * 1000) * 1)
	var seconds = int(fmod(time, 60))
	var minutes = int(fmod(time,3600) / 60)
	var msecdisplay = node.get_child(2)
	var secdisplay = node.get_child(1)
	var mindisplay = node.get_child(0)
	
	@warning_ignore("integer_division")
	var mins = [int((minutes/10)%10),int(minutes%10)]
	@warning_ignore("integer_division")
	var secs = [int((seconds/10)%10),int(seconds%10)]
	@warning_ignore("integer_division")
	var msecs = [int((msec/100)%10),int((msec/10)%10),int(msec%10)]
	for i in mindisplay.get_child_count():
		mindisplay.get_child(i).frame = mins[i]
	for i in secdisplay.get_child_count():
		secdisplay.get_child(i).frame = secs[i]
	for i in msecdisplay.get_child_count():
		msecdisplay.get_child(i).frame = msecs[i]

func updatescore(num,node):
	if num <= 99999:
		var scores = [int((num/100000)%10),int((num/10000)%10),int((num/1000)%10),int((num/100)%10),int((num/10)%10),int(num%10)]
		for i in node.get_child_count():
			node.get_child(i).frame = scores[i] if scores[i] >= 0 else 0
	else:
		for i in node.get_child_count():
			node.get_child(i).frame = 9
