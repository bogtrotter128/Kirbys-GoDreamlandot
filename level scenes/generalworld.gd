extends Node2D
@export var camlimit = Vector4(0,0,0,0) #up, down, left, right
@export var playerpos = Vector2(0,0) #sets plyarer pos on start
var custompos = Vector2(0,0) #sets player pos if different from start. set by doors.

func _ready():
	self.add_to_group("room")
	if get_parent().name == "mainWorldScene":
		GameUtils.CANRECALL = false
		get_parent().black()
		repos(custompos)
		get_parent().setcameralimits(camlimit)
		await get_tree().create_timer(0.3).timeout
		get_parent().fade_from_black()
		await get_tree().create_timer(0.3).timeout
		GameUtils.CANRECALL = true
	else:
		print(get_parent().name)

func repos(pos):
	if pos.x != 0 && pos.y != 0:
		get_parent().setplayerposition(pos)
		custompos = Vector2(0,0)
	else:
		get_parent().setplayerposition(playerpos)
