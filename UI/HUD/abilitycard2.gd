extends HBoxContainer

var loadstagepath = ""
func _process(_delta):
	if Hud.upability2 == true:
		update_ability_card2()
		Hud.upability2 = false

func update_ability_card2():
	loadstagepath = "res://kirbySprites/UI/HUD/acard" + str(GameUtils.ABILITYP2) + ".png"
	print(loadstagepath)
	$cardSprite.texture = load(loadstagepath)
