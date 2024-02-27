extends Node2D

func _ready():
	$playerloadinscene.cameralimits(-111,256,0,3696)
	$playerloadinscene.playerposition(Vector2(80,60),Vector2(40,40))
