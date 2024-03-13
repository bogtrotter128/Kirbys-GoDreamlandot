extends StaticBody2D

var score = 50
var rng = RandomNumberGenerator.new()
var ranint = rng.randi_range(0,46)

func _ready():
	$Sprite2D.frame = ranint
