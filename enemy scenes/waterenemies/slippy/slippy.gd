extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".SPEED = 40

func _physics_process(_delta):
	
	if $"..".is_on_floor():
		$"..".SPEED = 0
		$"../AnimatedSprite2D".play("idle")
	else:
		$"..".SPEED = 40
	if $"..".swim == true:
		$"../AnimatedSprite2D".play("swim")
		swimphys()
	if $"..".is_on_floor(): # frog
		$"..".jump()
		$"../AnimatedSprite2D".play("jump")

func swimphys():
	if $"..".chase == true:
		$"..".GRAVITY = 15 * $"..".chaseY
	if $"..".chase == false:
		$"..".GRAVITY = 0
	
func _on_waterdetect_body_entered(body):
	if body.name == "watertiles":
		$"..".swim = true
		$"..".GRAVITY = 0

func _on_waterdetect_body_exited(body):
	if body.name == "watertiles":
		$"..".swim = false
		$"..".GRAVITY = 200
		$"..".velocity.y = -150
