extends HBoxContainer

var heart_full = preload("res://kirbySprites/UI/HUD/HPFULL2.png")
var heart_empty = preload("res://kirbySprites/UI/HUD/HPEMPTY.png")
var heart_half = preload("res://kirbySprites/UI/HUD/HPHALF2.png")

func update_health2(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty

func _ready():
	if GameUtils.SECONDPLAYER == false:
		$".".hide()
