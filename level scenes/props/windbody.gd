extends Area2D
#
@export var WINDX = 0.0
#a good y wind force is -300.0
@export var WINDY = 0.0

func _on_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("mobs"):
		body.WINDFORCEX = WINDX
		body.WINDFORCEY = WINDY

func _on_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("mobs"):
		body.WINDFORCEX = 0
		body.WINDFORCEY = 0
