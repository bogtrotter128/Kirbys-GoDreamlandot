extends Node
var HPcheck = 0
func _ready():
	$"..".SPEED = 50
	$"..".dirY = 1
	$"..".dirX = 0
	$"..".HP = 4
	$"..".velocityturn = false
	HPcheck = $"..".HP
func _physics_process(_delta):
	if $"..".chase == true:
		$"..".SPEED = 70
		$"../AnimatedSprite2D".play("chase")
	if $"..".HP < HPcheck:
		$"..".chase = true
	if $"..".chaseX > 0:
		$"../AnimatedSprite2D".flip_h = true
	else:
		$"../AnimatedSprite2D".flip_h = false
	$"..".targetmath()

func _on_fliptimery_timeout():
	$"..".dirY *= -1
