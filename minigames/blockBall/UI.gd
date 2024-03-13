extends Sprite2D
@onready var main = $"../.."
@onready var acardlist = [
	preload("res://kirbySprites/UI/HUD/acard0.png"),
	preload("res://kirbySprites/UI/HUD/acard1.png"),
	preload("res://kirbySprites/UI/HUD/acard2.png"),
	preload("res://kirbySprites/UI/HUD/acard0.png"),
	preload("res://kirbySprites/UI/HUD/acard4.png"),
	preload("res://kirbySprites/UI/HUD/acard5.png")
]

func updateUI(ballnum):
	updatescore()
	updateball(ballnum)
	updatestage()
	updateability()

func updatescore():
	if main.score < 99999:
		var scores = [int((main.score/100000)%10),int((main.score/10000)%10),int((main.score/1000)%10),int((main.score/100)%10),int((main.score/10)%10),int(main.score%10)]
		for i in $score.get_child_count():
			$score.get_child(i).frame = scores[i] if scores[i] >= 0 else 0
	else:
		for i in $score.get_child_count():
			$score.get_child(i).frame = 9

func updateball(ballnum):
	@warning_ignore("integer_division")
	var ballscore = [int((ballnum/10)%10),int(ballnum%10)]
	for i in $ball.get_child_count():
		if ballnum >= 0:
			$ball.get_child(i).frame = ballscore[i]
		else:
			$ball.get_child(i).frame = 0

func updatestage():
	var stagescore = [int((main.stagescore/10)%10),int(main.stagescore%10)]
	for i in $stage.get_child_count():
		$stage.get_child(i).frame = stagescore[i]

func updateability():
	$abilitycard1/Sprite2D.texture = acardlist[GameUtils.ABILITY]
	if GameUtils.SECONDPLAYER == true:
		$abilitycard2/Sprite2D2.texture = acardlist[GameUtils.ABILITYP2]
