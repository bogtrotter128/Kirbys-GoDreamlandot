extends Node
var room = load(GameUtils.roomloaded)
var tempcollectablelist = []

func _ready():
	room = load("res://debug_world.tscn")
	loadroom()

func setcameralimits(campos):
	$playerloadinscene/Camera2D.set_limit(SIDE_TOP, campos.x)
	$playerloadinscene/Camera2D.set_limit(SIDE_BOTTOM, campos.y)
	$playerloadinscene/Camera2D.set_limit(SIDE_LEFT, campos.z)
	$playerloadinscene/Camera2D.set_limit(SIDE_RIGHT, campos.w)

func setplayerposition(pos):
	for node in get_tree().get_nodes_in_group("player"):
		node.position = pos
	$playerloadinscene/Camera2D.position = pos

func clearcollectables():
	for i in tempcollectablelist.size():
		if tempcollectablelist[i] != null:
			tempcollectablelist[i].queue_free()
#loads the starting room when main_world_scene is first instanced
func loadroom():
	add_child(room.instantiate())
func black():
	$"screentransition/screen transition/AnimationPlayer".play("black")
func fade_to_black():
	$"screentransition/screen transition/AnimationPlayer".play("fade_to_black")
func fade_from_black():
	$"screentransition/screen transition/AnimationPlayer".play("fade_from_black")
