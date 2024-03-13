extends StaticBody2D

@export var starscore = 1
var score = 10

func _ready():
	$AnimatedSprite2D.play(str(starscore))
	if starscore == 1:
		score = 5
	if starscore == 2:
		score = 10
	else:
		score = 30

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
