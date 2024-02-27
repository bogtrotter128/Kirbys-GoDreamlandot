extends Node
var floating = false
func _ready():
	$"..".copyAbilityScore = 7

func _physics_process(_delta):
	if $"..".is_on_floor() && floating == true:
		floating = false
		$"..".GRAVITY = 200
		$"../AnimatedSprite2D".play("hurt")
		$"..".SPEED = 0
		await get_tree().create_timer(0.2).timeout
		$"..".SPEED = 80
		$"../AnimatedSprite2D".play("default")
	if not $"..".is_on_floor():
		$"..".GRAVITY = 60
		floating = true
		$"../AnimatedSprite2D".play("float")
