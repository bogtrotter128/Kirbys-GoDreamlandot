extends HBoxContainer

var abilitycardlist = [
preload("res://kirbySprites/UI/HUD/acard0.png"),
preload("res://kirbySprites/UI/HUD/acard1.png"),
preload("res://kirbySprites/UI/HUD/acard2.png"),
preload("res://kirbySprites/UI/HUD/acard3.png"),
preload("res://kirbySprites/UI/HUD/acard4.png"),
preload("res://kirbySprites/UI/HUD/acard5.png"),
preload("res://kirbySprites/UI/HUD/acard6.png"),
preload("res://kirbySprites/UI/HUD/acard7.png"),
preload("res://kirbySprites/UI/HUD/acard8.png")
]
func _process(_delta):
	if Hud.upability2 == true:
		update_ability_card2(GameUtils.ABILITYP2)
		Hud.upability2 = false

func update_ability_card2(value):
	$cardSprite.texture = abilitycardlist[value]
