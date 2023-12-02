extends HBoxContainer

var ebar_full = preload("res://kirbySprites/UI/HUD/enemybar2.png")
var ebar_empty = preload("res://kirbySprites/UI/HUD/enemybar0.png")
var ebar_half = preload("res://kirbySprites/UI/HUD/enemybar1.png")

func update_enemy_bar(value):
	update_partial(value)
	
func update_partial(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = ebar_full
		elif value > i * 2:
			get_child(i).texture = ebar_half
		else:
			get_child(i).texture = ebar_empty
