extends Node
var watercheck = false
func _ready():
	$"..".SPEED = 30
	$"..".dirY = 1
	$"..".HP = 3

func _physics_process(_delta):
	if watercheck == true:
		$"..".dirY = 1
		$"..".velocity.y = 200

func _on_fliptimery_timeout():
	$"..".dirY *= -1

func _on_water_detect_body_exited(body):
	if body == null:
		pass
	if body.name == "watertiles":
		watercheck = true
		$"..".chase = false
		$"../breathtimer".start()
func _on_water_detect_body_entered(body):
	if body == null:
		pass
	if body.name == "watertiles":
		watercheck = false
		$"..".velocity.y /= 2
		$"../breathtimer".stop()
func _on_breathtimer_timeout():
	$"..".death()
