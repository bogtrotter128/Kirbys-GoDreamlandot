extends HBoxContainer

var star0 = preload("res://kirbySprites/UI/HUD/STAR0.png")
var star1 = preload("res://kirbySprites/UI/HUD/STAR1.png")
var star2 = preload("res://kirbySprites/UI/HUD/STAR2.png")
var star3 = preload("res://kirbySprites/UI/HUD/STAR3.png")
var star4 = preload("res://kirbySprites/UI/HUD/STAR4.png")
var star5 = preload("res://kirbySprites/UI/HUD/STAR5.png")
#the star updater and 1up system are in the score script
var canupdate = false
func _process(_delta):
	if Hud.starbarup == true && canupdate == true && tempvar < GameUtils.STARS:
		canupdate = false
		tempvar += 1
		update_stars(tempvar)
	if tempvar == GameUtils.STARS:
		Hud.starbarup = false

var tempvar = 0
func update_stars(value):
	for i in get_child_count():
		if i == 3: #this makes it skip the middle bit
			value += 5
		if i != 3: #this makes sur ethe middle doesnt update
			if value > i * 5 + 4:
				get_child(i).texture = star5
			elif value > i * 5 + 3:
				get_child(i).texture = star4
			elif value > i * 5 + 2:
				get_child(i).texture = star3
			elif value > i * 5 + 1:
				get_child(i).texture = star2
			elif value > i * 5:
				get_child(i).texture = star1
			else:
				get_child(i).texture = star0
