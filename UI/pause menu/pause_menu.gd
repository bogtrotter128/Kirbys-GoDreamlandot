extends Control

@onready var main = $"../../"
var optionmenu = false
var jumpsop = false
var healthop = false
var abilityop = false

var sfx = {
	"pause" : preload("res://kirbySprites/sfx/pause.wav"),
	"menuselect" : preload("res://kirbySprites/sfx/menu-select.wav"),
	"back" : preload("res://kirbySprites/sfx/enter-door.wav")
}

var selected = 1
var bglist = [
	preload("res://kirbySprites/UI/pause screen/pause menu art.png"),
	preload("res://kirbySprites/UI/pause screen/pausemenu options.png"),
	preload("res://kirbySprites/UI/pause screen/pausemenu coop.png"),
	preload("res://kirbySprites/UI/pause screen/pausemenu exit.png")
]
var oplist = [
	preload("res://kirbySprites/UI/pause screen/optionsback.png"),
	preload("res://kirbySprites/UI/pause screen/optionsjump.png"),
	preload("res://kirbySprites/UI/pause screen/optionshealth.png"),
	preload("res://kirbySprites/UI/pause screen/optionsability.png")
]
var checklist = [
	preload("res://kirbySprites/UI/pause screen/checkoff.png"),
	preload("res://kirbySprites/UI/pause screen/checkon.png")
]
func _ready():
	set_process_input(false)

func _input(_event):
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("P2up"):
		selected -= 1
		selected = 4 if selected < 1 else selected
		movestart()
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("P2down"):
		selected += 1
		selected = 1 if selected > 4 else selected
		movestart()
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("P2jump"):
		select()
	if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("P2a"):
		select()
	if Input.is_action_just_pressed("start"):
		cont()
		Sfxhandler.play_sfx(sfx["back"],get_parent())

func movestart():
	$bg.texture = bglist[selected - 1] if optionmenu == false else oplist[selected - 1]
	Sfxhandler.play_sfx(sfx["menuselect"],get_parent())
	var poslist = [94,128,154,184]
	$starselecter.position.y = poslist[selected -1]
func select():
	if optionmenu == true:
		if selected == 1:
			back()
			Sfxhandler.play_sfx(sfx["back"],get_parent())
		if selected == 2:
			opjumps()
			Sfxhandler.play_sfx(sfx["pause"],get_parent())
		if selected == 3:
			ophealth()
			Sfxhandler.play_sfx(sfx["pause"],get_parent())
		if selected == 4:
			opabilities()
			Sfxhandler.play_sfx(sfx["pause"],get_parent())
		checkupdate()
	else:
		if selected == 1:
			cont()
		if selected == 2:
			options()
			Sfxhandler.play_sfx(sfx["back"],get_parent())
		if selected == 3:
			coop()
			Sfxhandler.play_sfx(sfx["pause"],get_parent())
		if selected == 4:
			exit()
			Sfxhandler.play_sfx(sfx["back"],get_parent())
#pause menu items
func cont():
	optionmenu = false
	$VBoxContainer.hide()
	main.pauseMenu()
func options():
	selected = 1
	optionmenu = true
	movestart()
	$VBoxContainer.show()
func coop():
	if GameUtils.SECONDPLAYER == false:
		main.gooeyspawn()
	GameUtils.SECONDPLAYER = !GameUtils.SECONDPLAYER
	main.pauseMenu()
func exit():
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")
#options menu items
func back():
	optionmenu = false
	movestart()
	$VBoxContainer.hide()
func opjumps():
	GameUtils.JUMPMAX = 99999 if GameUtils.JUMPMAX < 99999 else 1
	print(GameUtils.JUMPMAX)
func ophealth():
	GameUtils.MAXHP = 10 if GameUtils.MAXHP == 99999 else 99999
	GameUtils.MAXHPP2 = 10 if GameUtils.MAXHPP2 == 99999 else 99999
	await get_tree().create_timer(0.1).timeout
	GameUtils.HEALTH = GameUtils.MAXHP
	GameUtils.HEALTHP2 = GameUtils.MAXHPP2
func opabilities():
	GameUtils.opAbilities = !GameUtils.opAbilities

func checkupdate():
	$VBoxContainer/TextureRect.texture = checklist[1] if GameUtils.JUMPMAX == 99999 else checklist[0]
	$VBoxContainer/TextureRect2.texture = checklist[1] if GameUtils.MAXHP == 99999 else checklist[0]
	$VBoxContainer/TextureRect3.texture = checklist[1] if GameUtils.opAbilities == true else checklist[0]
