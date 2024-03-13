extends Node2D

func _process(_delta):
	if GameUtils.STARS == 30 && GameUtils.SCORES1UP != 99:
		GameUtils.STARS = 0
		if GameUtils.SCORES1UP < 99:
			GameUtils.SCORES1UP +=1
		update_1up_score(GameUtils.SCORES1UP)

func update_1up_score(value):
	var numvals = [int((value/10)%10),int(value%10)]
	for i in get_child_count():
		get_child(i).frame = numvals[i]
