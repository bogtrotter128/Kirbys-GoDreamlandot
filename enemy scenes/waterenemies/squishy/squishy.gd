extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".SPEED = 30

func _physics_process(_delta):
	if $"..".swim == true:
		swimphys()

func swimphys():
	if $"..".chase == true:
		$"..".GRAVITY = 25 * $"..".chaseY
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
		$"..".velocity.y = -250
