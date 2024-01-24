extends Sprite2D

var pLst = []
var pathStr
var selectedstage = 1
var unlockedstagemax
func _ready():
	update_title(GameUtils.levelval)
	update_art(GameUtils.levelval)
	
	for i in range(1, 7):
		pathStr = "res://kirbySprites/stageselect/" + str((GameUtils.levelval * 10) + i) + ".png"
		pLst.append(pathStr)
	update_portrait_vals()
	
	
	#forgive me alfred
	if GameUtils.levelval == 1:
		unlockedstagemax = GameUtils.stageval1
	if GameUtils.levelval == 2:
		unlockedstagemax = GameUtils.stageval2
	if GameUtils.levelval == 3:
		unlockedstagemax = GameUtils.stageval3
	if GameUtils.levelval == 4:
		unlockedstagemax = GameUtils.stageval4
	if GameUtils.levelval == 5:
		unlockedstagemax = GameUtils.stageval5
		
	if unlockedstagemax < 7:
		$bossportrait.visible = false
	update_boss_portraits(GameUtils.levelval)

func _input(_event):
	if Input.is_action_just_pressed("up"): #debug noise
		unlockedstagemax += 1
		update_boss_portraits(GameUtils.levelval)
		if unlockedstagemax < 7:
			update_portraits(unlockedstagemax)
	#
	if Input.is_action_just_pressed("a"):
		loadstage()
	if Input.is_action_just_pressed("right") && selectedstage +1 <= unlockedstagemax or Input.is_action_just_pressed("right") && unlockedstagemax > 6:
		spritemoveright($selectionboxsprite)
		selectedstage += 1
		print(selectedstage)
	
	if Input.is_action_just_pressed("left") && selectedstage != 0 && unlockedstagemax < 7 or Input.is_action_just_pressed("left") && unlockedstagemax >= 7: 
			spritemoveleft($selectionboxsprite)
			selectedstage -= 1
			print(selectedstage)

func spritemoveleft(sprite):
	if selectedstage == 0 or selectedstage == 7 or selectedstage == 1:
		sprite.position.x -= 28
	else:
		sprite.position.x -= 24

func spritemoveright(sprite):
	if selectedstage == 0 or selectedstage == 7 or selectedstage == 6:
		sprite.position.x += 28
	else:
		sprite.position.x += 24

func _process(_delta):
	if selectedstage < 0:
		selectedstage = 7
		$selectionboxsprite.position.x = 88
	elif selectedstage > 7:
		selectedstage = 0
		$selectionboxsprite.position.x = -88
	if selectedstage == 0 or selectedstage == 7:
		$selectionboxsprite.play("big")
	else:
		$selectionboxsprite.play("small")

var titlecardlist = [
	preload("res://kirbySprites/stageselect/grassland title.png"),
	preload("res://kirbySprites/stageselect/ripplefield title.png"),
	preload("res://kirbySprites/stageselect/sandcanyon title.png"),
	preload("res://kirbySprites/stageselect/cloud park title.png"),
	preload("res://kirbySprites/stageselect/iceberg title.png")
	]

func update_title(value):
	$HBoxContainer/stagename.texture = titlecardlist[value - 1]

var artlist = [
	preload("res://kirbySprites/stageselect/grasslands.png"),
	preload("res://kirbySprites/stageselect/ripplefield.png"),
	preload("res://kirbySprites/stageselect/sandcanyon.png"),
	preload("res://kirbySprites/stageselect/cloud park.png"),
	preload("res://kirbySprites/stageselect/iceberg.png")
	]

func update_art(value):
	$stageart.texture = artlist[value - 1]

var bosslist = [
	preload("res://kirbySprites/stageselect/whipsytitle.png"),
	preload("res://kirbySprites/stageselect/acrotitle.png"),
	preload("res://kirbySprites/stageselect/poncontitle.png"),
	preload("res://kirbySprites/stageselect/adotitle.png"),
	preload("res://kirbySprites/stageselect/dededetitle.png")
	]

var bosspiclist = [
	preload("res://kirbySprites/stageselect/whispycard.png"),
	preload("res://kirbySprites/stageselect/acrocard.png"),
	preload("res://kirbySprites/stageselect/ponconcard.png"),
	preload("res://kirbySprites/stageselect/adocard.png"),
	preload("res://kirbySprites/stageselect/dededecard.png")
	]

func update_boss_portraits(value):
	$bossname.texture = bosslist[value - 1]
	
	if unlockedstagemax == 7:
		$bossportrait.visible = true
		$bossportrait.texture = bosspiclist[value -1]

func update_portraits(stagescore):
	$levelportraits.get_child(stagescore-1).texture = load(pLst[stagescore-1])

func update_portrait_vals():
	if GameUtils.levelval == 1:
		update_portraits(GameUtils.stageval1)
	if GameUtils.levelval == 2:
		update_portraits(GameUtils.stageval2)
	if GameUtils.levelval == 3:
		update_portraits(GameUtils.stageval3)
	if GameUtils.levelval == 4:
		update_portraits(GameUtils.stageval4)
	if GameUtils.levelval == 5:
		update_portraits(GameUtils.stageval5)

var loadstagepath
func loadstage():
	if selectedstage == 0:
		get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")
	else:
		loadstagepath = "res://level scenes/" + str((GameUtils.levelval * 10) + selectedstage) + ".tscn"
		get_tree().change_scene_to_file(loadstagepath)
