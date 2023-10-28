extends HBoxContainer

enum modes {SIMPLE, EMPTY, PARTIAL}

var star0 = preload("res://kirbySprites/UI/HUD/STAR0.png")
var star1 = preload("res://kirbySprites/UI/HUD/STAR1.png")
var star2 = preload("res://kirbySprites/UI/HUD/STAR2.png")
var star3 = preload("res://kirbySprites/UI/HUD/STAR3.png")
var star4 = preload("res://kirbySprites/UI/HUD/STAR4.png")
var star5 = preload("res://kirbySprites/UI/HUD/STAR5.png")


@export var mode : modes
func update_stars(value):
	update_partial(value)
	
func update_partial(value):
	for i in get_child_count():
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
