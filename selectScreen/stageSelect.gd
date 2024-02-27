extends Sprite2D

var pLst = []
var heartstars = []
var tokenposition = []

var unlockedstagemax

var pathStr
var selectedstage = 0
var loadstagepath
var levelname

var titlecardlist = [
	preload("res://kirbySprites/stageselect/grassland title.png"),
	preload("res://kirbySprites/stageselect/ripplefield title.png"),
	preload("res://kirbySprites/stageselect/sandcanyon title.png"),
	preload("res://kirbySprites/stageselect/cloud park title.png"),
	preload("res://kirbySprites/stageselect/iceberg title.png")
	]

var artlist = [
	preload("res://kirbySprites/stageselect/grasslands.png"),
	preload("res://kirbySprites/stageselect/ripplefield.png"),
	preload("res://kirbySprites/stageselect/sandcanyon.png"),
	preload("res://kirbySprites/stageselect/cloud park.png"),
	preload("res://kirbySprites/stageselect/iceberg.png")
	]

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

func _ready():
	update_title(GameUtils.levelval)
	update_art(GameUtils.levelval)
	updateplayertokens()
	
	for i in range(1, 7):
		pathStr = "res://kirbySprites/stageselect/" + str((GameUtils.levelval * 10) + i) + ".png"
		pLst.append(pathStr)
	update_boss_portraits(GameUtils.levelval)
	
	#forgive me alfred
	if GameUtils.levelval == 1:
		unlockedstagemax = GameUtils.stageval1
		heartstars = GameUtils.stage1HS
		tokenposition = [
			Vector2(-78,0),Vector2(-60,-30),Vector2(-26,-46),Vector2(-12,4),
			Vector2(45,2),Vector2(80,-11),Vector2(32,-45),Vector2(65,-40)
			]
		update_portraits(GameUtils.stageval1)
		levelname = "1grassland"
	if GameUtils.levelval == 2:
		unlockedstagemax = GameUtils.stageval2
		heartstars = GameUtils.stage2HS
		tokenposition = [
			Vector2(-72,7),Vector2(-62,-18),Vector2(-44,-44),Vector2(-14,-12),
			Vector2(31,-49),Vector2(67,-8),Vector2(84,-32),Vector2(76,-54)
			]
		update_portraits(GameUtils.stageval2)
		levelname = "2RippleField"
	if GameUtils.levelval == 3:
		unlockedstagemax = GameUtils.stageval3
		heartstars = GameUtils.stage3HS
		tokenposition = [
			Vector2(-72,2),Vector2(-70,-40),Vector2(-38,-14),Vector2(-11,-27),
			Vector2(19,-12),Vector2(56,6),Vector2(37,-23),Vector2(79,-49)
			]
		update_portraits(GameUtils.stageval3)
		levelname = "3SandCanyon"
	if GameUtils.levelval == 4:
		unlockedstagemax = GameUtils.stageval4
		heartstars = GameUtils.stage4HS
		tokenposition = [
			Vector2(-78,-16),Vector2(-66,-39),Vector2(-39,-49),Vector2(-16,-4),
			Vector2(20,-30),Vector2(60,0),Vector2(72,-36),Vector2(67,-58)
			]
		update_portraits(GameUtils.stageval4)
		levelname = "4CloudPark"
	if GameUtils.levelval == 5:
		unlockedstagemax = GameUtils.stageval5
		heartstars = GameUtils.stage5HS
		tokenposition = [
			Vector2(-84,8),Vector2(-61,-31),Vector2(-29,-38),Vector2(12,-9),
			Vector2(65,8),Vector2(65,-21),Vector2(72,-40),Vector2(72,-75)
			]
		update_portraits(GameUtils.stageval5)
		levelname = "5Iceberg"
	if unlockedstagemax < 7:
		$bossportrait.visible = false
	
	updateplayertokenposition()
	update_heartstars()

func _input(_event):
	if Input.is_action_just_pressed("up"): #debug noise
		unlockedstagemax += 1
		update_boss_portraits(GameUtils.levelval)
		if unlockedstagemax < 7:
			update_portraits(unlockedstagemax)
	#
	if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("start"):
		loadstage()
	if Input.is_action_pressed("right") && selectedstage +1 <= unlockedstagemax or Input.is_action_pressed("right") && unlockedstagemax > 6:
		spritemoveright($selectionboxsprite)
		selectedstage += 1
		print(selectedstage)
	
	if Input.is_action_pressed("left") && selectedstage != 0 && unlockedstagemax < 7 or Input.is_action_pressed("left") && unlockedstagemax >= 7: 
		spritemoveleft($selectionboxsprite)
		selectedstage -= 1
		print(selectedstage)
	await get_tree().create_timer(0.1).timeout
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
	
	updateplayertokenposition()

func update_title(value):
	$HBoxContainer/stagename.texture = titlecardlist[value - 1]

func update_art(value):
	$stageart.texture = artlist[value - 1]

func update_boss_portraits(value):
	$bossname.texture = bosslist[value - 1]
	
	if unlockedstagemax == 7:
		$bossportrait.visible = true
		$bossportrait.texture = bosspiclist[value -1]

func update_portraits(stagescore):
	$levelportraits.get_child(stagescore-1).texture = load(pLst[stagescore-1])

func update_heartstars():
	for i in $heartstars.get_child_count():
		$heartstars.get_child(i).visible = heartstars[i]
		await get_tree().create_timer(0.13).timeout
		$heartstars.get_child(i).play("default")

func updateplayertokens():
	if GameUtils.FRENVAL > 0:
		$playersprites/animalfriend1.play(str(GameUtils.FRENVAL))
	else:
		$playersprites/animalfriend1.hide()
	if GameUtils.FRENVALP2 > 0:
		$playersprites/animalfriend2.play(str(GameUtils.FRENVALP2))
	else:
		$playersprites/animalfriend2.hide()
	if GameUtils.SECONDPLAYER == false:
		$playersprites/gooeypoint.hide()
		$playersprites/animalfriend2.hide()

func updateplayertokenposition():
	$playersprites.position = tokenposition[selectedstage]

func loadstage():
	if selectedstage == 0:
		get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")
	else:
		loadstagepath = "res://level scenes/"+ levelname + "/" +str((GameUtils.levelval * 10) + selectedstage) + ".tscn"
		get_tree().change_scene_to_file(loadstagepath)
