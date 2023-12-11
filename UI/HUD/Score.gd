extends HBoxContainer

var score0 = preload("res://kirbySprites/UI/HUD/0.png")
var score1 = preload("res://kirbySprites/UI/HUD/1.png")
var score2 = preload("res://kirbySprites/UI/HUD/2.png")
var score3 = preload("res://kirbySprites/UI/HUD/3.png")
var score4 = preload("res://kirbySprites/UI/HUD/4.png")
var score5 = preload("res://kirbySprites/UI/HUD/5.png")
var score6 = preload("res://kirbySprites/UI/HUD/6.png")
var score7 = preload("res://kirbySprites/UI/HUD/7.png")
var score8 = preload("res://kirbySprites/UI/HUD/8.png")
var score9 = preload("res://kirbySprites/UI/HUD/9.png")

func _process(_delta):
	if GameUtils.STARS == 30 && GameUtils.SCORES1UP != 99:
		GameUtils.STARS = 0
		if GameUtils.SCORES1UP < 99:
			GameUtils.SCORES1UP +=1
		update_1up_score(GameUtils.SCORES1UP)

func update_1up_score(value):
	for i in get_child_count():
		if value % 10 != 0:
			i = 0
		if value % 10 > i * 9 + 8:
			get_child(i).texture = score9
		elif value % 10 > i * 9 + 7:
			get_child(i).texture = score8
		elif value % 10 > i * 9 + 6:
			get_child(i).texture = score7
		elif value % 10 > i * 9 + 5:
			get_child(i).texture = score6
		elif value % 10 > i * 9 + 4:
			get_child(i).texture = score5
		elif value % 10 > i * 9 + 3:
			get_child(i).texture = score4
		elif value % 10 > i * 9 + 2:
			get_child(i).texture = score3
		elif value % 10 > i * 9 + 1:
			get_child(i).texture = score2
		elif value % 10 > i * 9:
			get_child(i).texture = score1
		else:
			get_child(i).texture = score0
		if value % 10 == 0:
			i = 0
	if value >= 90 && value < 100:
		$num2.texture = score9
	elif value >= 80 && value < 90:
		$num2.texture = score8
	elif value >= 70 && value < 80:
		$num2.texture = score7
	elif value >= 60 && value < 70:
		$num2.texture = score6
	elif value >= 50 && value < 60:
		$num2.texture = score5
	elif value >= 40 && value < 50:
		$num2.texture = score4
	elif value >= 30 && value < 40:
		$num2.texture = score3
	elif value >= 20 && value < 30:
		$num2.texture = score2
	elif value>= 10 && value < 20:
		$num2.texture = score1
	elif value < 10:
		$num2.texture = score0
