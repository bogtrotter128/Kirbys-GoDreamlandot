extends Node

var up = false
var down = false

func _process(_delta):
	if $"..".DIR == -1 && $"..".overrideX == false && $"../AnimatedSprite2D".flip_h == false:
		$"../AnimatedSprite2D".flip_h = true
		$"../AnimatedSprite2D".turnframe()
	if $"..".DIR == 1 && $"..".overrideX == false && $"../AnimatedSprite2D".flip_h == true:
		$"../AnimatedSprite2D".flip_h = false
		$"../AnimatedSprite2D".turnframe()

	var direction = Input.get_axis($"..".LEFT, $"..".RIGHT)
	#rotation rules for blowing animations
	if $"..".swim == true && $"..".overrideX == false && $"..".hasAbility == false && not $"..".is_on_floor():
		if Input.is_action_pressed($"..".UP):
			up = true
			down = false
		if Input.is_action_pressed($"..".DOWN):
			down = true
			up = false
		if Input.is_action_pressed($"..".LEFT) or Input.is_action_pressed($"..".RIGHT):
			up = false
			down = false

	if  $"..".activeAbility > 0:
		$"../AnimatedSprite2D".abilityani()
	if $"..".activeAbility == 0 && $"..".swim == false or $"..".is_on_floor() && $"../animalfriendcode".bubblestart == true && $"..".activeAbility == 0 or $"..".mouthFull == true:
		$"../AnimatedSprite2D".ani(direction)
	if $"..".swim == true && not $"..".is_on_floor() && $"..".mouthFull == false or $"../animalfriendcode".bubblestart == false:
		$"../AnimatedSprite2D".swimani(up,down)
	
	if $"..".hurt == true && $"..".mouthFull == false:
		$"../AnimatedSprite2D".play("hurt")
	elif $"..".hurt == true && $"..".mouthFull == true:
		$"../AnimatedSprite2D".play("fat hurt")
