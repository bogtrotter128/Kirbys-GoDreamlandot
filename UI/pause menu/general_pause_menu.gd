extends Control

@onready var main = $"../../"

var sfxlist = ["pause","menuselect","back"]
var sfx = {
	"pause" : preload("res://kirbySprites/sfx/pause.wav"),
	"menuselect" : preload("res://kirbySprites/sfx/menu-select.wav"),
	"back" : preload("res://kirbySprites/sfx/enter-door.wav")
}

var selected = 1

func _ready():
	set_process_input(false)

func _input(_event):
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("P2up"):
		selected -= 1
		selected = 3 if selected < 1 else selected
		movestart()
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("P2down"):
		selected += 1
		selected = 1 if selected > 3 else selected
		movestart()
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("P2jump"):
		select()
	if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("P2a"):
		select()
	if Input.is_action_just_pressed("start"):
		cont()
		Sfxhandler.play_sfx(sfx["back"],get_parent())

func movestart():
	Sfxhandler.play_sfx(sfx["menuselect"],get_parent())
	if selected == 1:
		$starselecter.position.y = 114
	if selected == 2:
		$starselecter.position.y = 150
	if selected == 3:
		$starselecter.position.y = 180
	if selected == 4:
		$starselecter.position.y = 210
func select():
	if selected == 1:
		cont()
	if selected == 2:
		coop()
	if selected == 3:
		exit()
func cont():
	Sfxhandler.play_sfx(sfx["back"],get_parent())
	main.pauseMenu()
func coop():
	GameUtils.SECONDPLAYER = !GameUtils.SECONDPLAYER
	$"../..".secondplayerrules()
	Sfxhandler.play_sfx(sfx["pause"],get_parent())
	main.pauseMenu()
func exit():
	Sfxhandler.play_sfx(sfx["back"],get_parent())
	get_tree().paused = false
	get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")
