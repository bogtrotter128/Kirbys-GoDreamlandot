extends Sprite2D

var targetdegree = 0
var spinspeed = 0
var tempscore
var levelscore = 1
var popstar = true
var darkstar = false
var selected = 0
var extras = false
var extracoords = [Vector2(-1,-120),
	Vector2(-116,-90),Vector2(-169,-16),Vector2(-108,98),
	Vector2(103,92),Vector2(148,12),Vector2(85,-100)]
var showeyecount = 0

var sfx = {
	"menu_select" : preload("res://kirbySprites/sfx/menu-select.wav"),
	"cantselect" : preload("res://kirbySprites/sfx/toss.wav"),
	"enter_select" : preload("res://kirbySprites/sfx/enter-door.wav"),
	"pausesound" : preload("res://kirbySprites/sfx/pause.wav"),
	"eyesound" : preload("res://kirbySprites/sfx/woosh2.wav")
}

func _ready():
	levelscore = GameUtils.levelval
	$popstar.rotation_degrees -= 72 * (GameUtils.levelval - 1)
	targetdegree = $popstar.rotation_degrees
	reupdate_darkstar()
	updateplayertokens()
	updateextrastars()

func _input(_event):
	if Input.is_action_pressed("left") or Input.is_action_pressed("P2left"):
		if popstar == true:
			popstarinput(-1)
		if extras == true:
			extrainput(1)
	if Input.is_action_pressed("right") or Input.is_action_pressed("P2right"):
		if popstar == true:
			popstarinput(1)
		if extras == true:
			extrainput(-1)
	#level select
	if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("P2a") or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("P2jump"):
		if popstar == true:
			Sfxhandler.play_sfx(sfx["enter_select"],get_parent())
			GameUtils.levelval = levelscore
			await get_tree().create_timer(0.1).timeout
			stageswitchscene()
		if darkstar == true:
			print("level 6")
		if extras == true:
			if selected < GameUtils.levelmax or GameUtils.levelmax > 5:
				Sfxhandler.play_sfx(sfx["enter_select"],get_parent())
				await get_tree().create_timer(0.1).timeout
				extraswitchscene(selected)
			if selected > GameUtils.levelmax:
				Sfxhandler.play_sfx(sfx["cantselect"],get_parent())
			
	#moves up around the menu
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("P2up"):
		if popstar == true:
			$playersprites.position.y -= 40
			popstar = false
			extras = true
			Sfxhandler.play_sfx(sfx["pausesound"],get_parent())
			extrainput(0)
		if darkstar == true:
			Sfxhandler.play_sfx(sfx["pausesound"],get_parent())
			darkstar = false
			levelscore = tempscore
			popstar = true
		if extras == true:
			Sfxhandler.play_sfx(sfx["cantselect"],get_parent())
		
	#moves down around the menu
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("P2down"):
		if popstar == true:
			if GameUtils.HEARTSTARS >= 30:
				popstar = false
				darkstar = true
				tempscore = levelscore
				levelscore = 6
				levelsprite()
				$playersprites.position.y = -20
			else:
				showeye()
		if extras == true:
			extras = false
			Sfxhandler.play_sfx(sfx["pausesound"],get_parent())
			$playersprites.position.x = -1
			$playersprites.scale = Vector2(1,1)
			await get_tree().create_timer(0.1).timeout
			popstar = true
	if Input.is_action_just_released("left") or Input.is_action_just_released("right") or Input.is_action_just_released("P2left") or Input.is_action_just_released("P2right"):
		spinspeed = 0

func popstarinput(dir):
	if dir == -1 && $popstar.rotation_degrees == targetdegree:
		if levelscore != 1 && GameUtils.levelmax < 5 or GameUtils.levelmax >= 5:
			targetdegree += 72
			levelscore -= 1
			levelscore = 5 if levelscore < 1 else levelscore
			Sfxhandler.play_sfx(sfx["menu_select"],get_parent())
		spinspeed +=1
	if dir == 1 && $popstar.rotation_degrees == targetdegree:
		if levelscore + 1 <= GameUtils.levelmax or levelscore == 5:
			targetdegree -= 72
			levelscore += 1
			levelscore = 1 if levelscore > 5 else levelscore
			Sfxhandler.play_sfx(sfx["menu_select"],get_parent())
		spinspeed +=1

func extrainput(dir):
	if $playersprites.position == extracoords[selected]:
		Sfxhandler.play_sfx(sfx["menu_select"],get_parent())
		selected += dir
		spinspeed +=1
		selected = 6 if selected < 0 else selected
		selected = 0 if selected > 6 else selected
#	$playersprites.position = extracoords[selected]
	$playersprites.scale = Vector2(1.5,1.5)

func _process(_delta):
	if popstar == true:
		popstarspin()
	if extras == true:
		extrastarmapmove()
	levelsprite()
#tween
	if cantween == true:
		tweener()
	if levelscore == 1 && $popstar.rotation_degrees == targetdegree:
		targetdegree = 0
		$popstar.rotation_degrees = 0

func popstarspin():
	if $popstar.rotation_degrees != targetdegree:
		$popstar.rotation_degrees = move_toward($popstar.rotation_degrees, targetdegree, 4 + (spinspeed/4.0))
		$playersprites.position.y = move_toward($playersprites.position.y,-20,4)
		print(targetdegree)
		print($popstar.rotation_degrees)
	if $popstar.rotation_degrees == targetdegree:
		$playersprites.position.y = move_toward($playersprites.position.y,-70,4)

func extrastarmapmove():
	var coordchop = extracoords[selected]
	$playersprites.position.x = move_toward($playersprites.position.x,coordchop.x,10 + spinspeed)
	$playersprites.position.y = move_toward($playersprites.position.y,coordchop.y,10 + spinspeed)

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

func levelsprite():
	if popstar == true or darkstar == true:
		if $popstar.rotation_degrees != targetdegree:
			$level/number.visible=false
			$level.play("disapear")
		if $popstar.rotation_degrees == targetdegree or levelscore == 6:
			$level/number.play(str(levelscore))
			$level/number.visible=true
			$level.play("default")
	if extras == true:
		$level/number.visible=false
		if selected < GameUtils.levelmax or GameUtils.levelmax > 5:
			$level.play(str(selected))
		if selected > GameUtils.levelmax:
			$level.play("?")

func showeye():
	$playersprites.position.y = -20
	showeyecount += 1
	
	if showeyecount % 3 == 0:
		$darkeye.visible = true
		$darkeye.play("large")
		Sfxhandler.play_sfx(sfx["eyesound"],get_parent())
		await get_tree().create_timer(0.2).timeout
		$darkeye.visible = false
	else:
		Sfxhandler.play_sfx(sfx["cantselect"],get_parent())

var cantween = true
func tweener():
	var tween = create_tween()
	tween.tween_property($popstar,"position",Vector2(1,1),0.2)
	tween.tween_property($popstar,"position",Vector2(0,0),0.2)
	tween.tween_property($popstar,"position",Vector2(1,-1),0.2)
	cantween = false
	$tweentimer.start()

func _on_tweentimer_timeout():
	cantween = true

func updateextrastars():
	for i in GameUtils.levelmax:
		$extrastars.get_child(i).play(str(i+1))

func reupdate_darkstar():
	#small dark gibbits
	var heartstarvarchecklist = [GameUtils.stage1HS,GameUtils.stage2HS,GameUtils.stage3HS,GameUtils.stage4HS,GameUtils.stage5HS]
	for i in heartstarvarchecklist.size():
		if heartstarvarchecklist[i] == [true,true,true,true,true,true]:
			$popstar/smalldark.get_child(i).visible = false
	#large dark gibbits
	for i in GameUtils.levelmax - 1:
		if i < 4: # tehre are only four children, if i goes over 4 it crashes
			$popstar/longdark.get_child(i).visible = false

	if GameUtils.HEARTSTARS == 30:
		$darkeye.visible = true
		$darkeye.play("large")
	if GameUtils.HEARTSTARS > 30:
		$darkeye.visible = true
		$darkeye.play("small")

func stageswitchscene():
	get_tree().change_scene_to_file("res://selectScreen/stageSelect.tscn")
func extraswitchscene(select):
	print(select)
