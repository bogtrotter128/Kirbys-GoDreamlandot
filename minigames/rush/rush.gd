extends Node2D
var lowestVELOCITY = 4.0 #set by each level
var VELOCITY = 4.0
var rushscore = 0

@onready var pause = $pausemenu/general_pause_menu
var paused = false

var rng = RandomNumberGenerator.new()
var ranint
@onready var prefablist = [
	preload("res://minigames/rush/pteran_hazard.tscn"),
	preload("res://minigames/rush/pteran_hazard.tscn"),
	preload("res://minigames/rush/pteran_hazard.tscn"),
	preload("res://minigames/rush/pteran_hazard.tscn"),
	preload("res://minigames/rush/hazardprefabs/pteran_3.tscn"),
	preload("res://minigames/rush/collectableprefabs/starline.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_3.tscn"),
	preload("res://minigames/rush/hazardprefabs/dark_gordo_1.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_1.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_1.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_2.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_3.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_3_line.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_h_line_5_red.tscn"),
	preload("res://minigames/rush/collectableprefabs/star_box.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_gap.tscn"),
	preload("res://minigames/rush/hazardprefabs/gordo_gap.tscn")
]

func _ready():
	VELOCITY = lowestVELOCITY
	if GameUtils.SECONDPLAYER == false:
		secondplayerrules()

func _input(_event):
	if Input.is_action_just_pressed("start"):
		pauseMenu()

func _physics_process(_delta):
	$Camera2D.position.x = move_toward($Camera2D.position.x, $Camera2D.position.x + 100, VELOCITY)

func _on_timer_timeout():
	rushscore += int(1 * VELOCITY)
	$"timer UI".updatescore(rushscore)

func _on_speed_timer_timeout():
	VELOCITY += (VELOCITY/8)
	$"speed timer".wait_time -= 0.25

func _on_prefabtimer_timeout():
	$Camera2D/player1.canhurt = true
	$Camera2D/player2.canhurt = true
	ranint = rng.randi_range(0,prefablist.size() - 1)
	var prefab = prefablist[ranint].instantiate()
	prefab.position = $Camera2D/Marker2D.global_position
	call_deferred("add_sibling", prefab)
	
func pauseMenu():
	if paused:
		pause.set_process_input(false)
		pause.hide()
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false
	else:
		pause.set_process_input(true)
		pause.show()
		get_tree().paused = true
	pause.selected = 1
	pause.movestart()
	paused = !paused

func secondplayerrules():
	$Camera2D/player2/Area2D/CollisionShape2D.disabled = !GameUtils.SECONDPLAYER
	$Camera2D/player2.set_process_input(GameUtils.SECONDPLAYER)
	$Camera2D/player2.set_physics_process(GameUtils.SECONDPLAYER)
	$Camera2D/player2/AnimatedSprite2D.visible = GameUtils.SECONDPLAYER
