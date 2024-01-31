extends HBoxContainer

var loadstagepath = ""
func _process(_delta):
	if Hud.upability == true:
		update_ability_card()
		Hud.upability = false

func update_ability_card():
	loadstagepath = "res://kirbySprites/UI/HUD/acard" + str(GameUtils.ABILITY) + ".png"
	print(loadstagepath)
	$cardSprite.texture = load(loadstagepath)
