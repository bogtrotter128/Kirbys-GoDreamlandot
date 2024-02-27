extends Node

func _ready():
	$"..".SPEED = 80

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		$"..".SPEED = 100
		$"../AnimatedSprite2D".play("run")
	
func _on_player_detect_body_exited(body):
	if body.is_in_group("player"):
		$"..".SPEED = 80
		$"../AnimatedSprite2D".play("default")
