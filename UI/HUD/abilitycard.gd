extends HBoxContainer

var blank0 = preload("res://kirbySprites/UI/HUD/acard0.png")
var flame1 = preload("res://kirbySprites/UI/HUD/acard1.png")
var shock2 = preload("res://kirbySprites/UI/HUD/acard2.png")
var ice3 = preload("res://kirbySprites/UI/HUD/acard3.png")
var rock4 = preload("res://kirbySprites/UI/HUD/acard4.png")
var spike5 = preload("res://kirbySprites/UI/HUD/acard5.png")
var cut6 = preload("res://kirbySprites/UI/HUD/acard6.png")
var para7 = preload("res://kirbySprites/UI/HUD/acard7.png")
var sweep8 = preload("res://kirbySprites/UI/HUD/acard8.png")

func _process(_delta):
	if Hud.upability == true:
		update_ability_card(GameUtils.ABILITY)
		Hud.upability = false

func update_ability_card(value):
	if value == 0:
		$cardSprite.texture = blank0
	if value == 1:
		$cardSprite.texture = flame1
	if value == 2:
		$cardSprite.texture = shock2
	if value == 3:
		$cardSprite.texture = ice3
	if value == 4:
		$cardSprite.texture = rock4
	if value == 5:
		$cardSprite.texture = spike5
	if value == 6:
		$cardSprite.texture = cut6
	if value == 7:
		$cardSprite.texture = para7
	if value == 8:
		$cardSprite.texture = sweep8
