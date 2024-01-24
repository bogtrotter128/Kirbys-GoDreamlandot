extends Sprite2D

var targetdegree = 0
var mashval = 0
var levelscore = 1

func _ready():
	reupdate_darkstar()

func _input(_event):
	if Input.is_action_just_released("left")&& levelscore != 1 && GameUtils.levelmax < 5 or Input.is_action_just_released("left") && GameUtils.levelmax >= 5:
		targetdegree += 72
		levelscore -= 1
		mashval += 1
		print(levelscore)
	if Input.is_action_just_released("right")&& levelscore + 1 < GameUtils.levelmax:
		targetdegree -= 72
		levelscore += 1
		mashval += 1
		print(levelscore)
	if Input.is_action_just_pressed("down") && GameUtils.HEARTSTARS == 30:
		pass #set up stuff for entering the final boss area
		
	if Input.is_action_just_pressed("a") && mashval == 0:
		GameUtils.levelval = levelscore
		stageswitchscene()

func _process(_delta):
	popstarspin()
	
	if levelscore > 5:
		levelscore = 1
		print(levelscore)
	elif levelscore < 1:
		levelscore = 5
		print(levelscore)
	
	levelsprite()
#tween
	if cantween == true:
		tweener()

func popstarspin():
	if $popstar.rotation_degrees != targetdegree && mashval < 5:
		$popstar.rotation_degrees = move_toward($popstar.rotation_degrees, targetdegree, 4)
	elif $popstar.rotation_degrees != targetdegree && mashval > 4:
		$popstar.rotation_degrees = move_toward($popstar.rotation_degrees, targetdegree, mashval)
	elif $popstar.rotation_degrees == targetdegree:
		mashval = 0

func levelsprite():
	if $popstar.rotation_degrees != targetdegree:
		$level/number.visible=false
		$level.play("disapear")
	elif $popstar.rotation_degrees == targetdegree:
		$level/number.play(str(levelscore))
		$level/number.visible=true
		$level.play("default")

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

func reupdate_darkstar():
	if GameUtils.stage1HS == [true,true,true,true,true,true]:
		$popstar/smalldark/Sprite2D.visible=false
	if GameUtils.stage2HS == [true,true,true,true,true,true]:
		$popstar/smalldark/Sprite2D2.visible=false
	if GameUtils.stage3HS == [true,true,true,true,true,true]:
		$popstar/smalldark/Sprite2D3.visible=false
	if GameUtils.stage4HS == [true,true,true,true,true,true]:
		$popstar/smalldark/Sprite2D4.visible=false
	if GameUtils.stage5HS == [true,true,true,true,true,true]:
		$popstar/smalldark/Sprite2D5.visible=false

func stageswitchscene():
	get_tree().change_scene_to_file("res://selectScreen/stageSelect.tscn")
