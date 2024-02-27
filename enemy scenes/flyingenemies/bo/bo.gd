extends Node

func _ready():
	$"..".SPEED = 40
	$"..".dirY = 1
	$"..".HP = 1

func _on_fliptimery_timeout():
	$"..".dirY *= -1
