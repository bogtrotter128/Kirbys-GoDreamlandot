extends Node2D


func _ready():
	$player/Camera2D.set_limit(SIDE_LEFT, 0)
	$player/Camera2D.set_limit(SIDE_TOP, -150)
	GameUtils.JUMPMAX = 999
 
