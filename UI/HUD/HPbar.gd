extends HBoxContainer

var heart_full = preload("res://kirbySprites/UI/HUD/HPFULL.png")
var heart_empty = preload("res://kirbySprites/UI/HUD/HPEMPTY.png")
var heart_half = preload("res://kirbySprites/UI/HUD/HPHALF.png")

var canupdate = false
func _process(_delta):
	if Hud.updatehpv == true && canupdate == true && tempvar != GameUtils.HEALTH:
		canupdate = false
		if tempvar > GameUtils.HEALTH:
			tempvar -= 1
		elif tempvar < GameUtils.HEALTH:
			tempvar += 1
		update_health(tempvar)
	if tempvar == GameUtils.HEALTH:
		Hud.updatehpv = false

	if GameUtils.SECONDPLAYER == true:
		$"../HPbar2".visible = true
	else:
		$"../HPbar2".visible = false
var tempvar = 0
func update_health(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty
