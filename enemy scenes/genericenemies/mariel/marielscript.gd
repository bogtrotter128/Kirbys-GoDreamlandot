extends Node

var cancheck = true
func _ready():
	$"..".patrol=false
	$"..".HP = 8
	$"..".copyAbilityScore = -1

func _physics_process(_delta):
	if $"..".patrol == false:
		$"..".SPEED = 0
	if $"..".patrol == true:
		targetmath()
	if $"..".is_on_wall():
		jump()

func _on_wall_detect_body_entered(body):
	if body.name == "watertiles":
		$"..".velocity /= 2
		$"..".GRAVITY = 10
		$"..".SPEED = 10
		await get_tree().create_timer(1.8).timeout
		$"..".death()

func _on_fall_detect_r_body_exited(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		jump()

func _on_fall_detect_l_body_exited(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		jump()

func _on_timer_timeout():
	cancheck = true
	hide()

func _on_player_detect_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("player") && cancheck == true:
		appear()
		await get_tree().create_timer(0.5).timeout
		cancheck = false
	if body.is_in_group("player") && cancheck == false:
		$"../runtimertimeout".stop()
func _on_player_detect_body_exited(body):
	if body == null:
		pass
	if body.is_in_group("player") && cancheck == false:
		$"../runtimertimeout".start()

func appear():
	$"../AnimatedSprite2D".play("apear")
	await $"../AnimatedSprite2D".animation_finished
	$"..".patrol=true
	$"..".SPEED = 90
	$"../AnimatedSprite2D".play("walk")

func hide():
	$"..".patrol=false
	$"..".velocity.x = 0
	$"../AnimatedSprite2D".play("disapear")
	await $"../AnimatedSprite2D".animation_finished
	$"../AnimatedSprite2D".play("hide")

func jump():
	if $"..".is_on_floor() && $"..".patrol == true:
		$"..".velocity.y = -170

var tempos
var tempos2
func targetmath():
	tempos = $"..".global_position.x - GameUtils.posX
	tempos2 = $"..".global_position.x - GameUtils.posXP2
	if tempos < 0:
		tempos *= -1
	if tempos2 < 0:
		tempos2 *= -1
	
	if tempos < tempos2:
		if GameUtils.posX < $"..".global_position.x:
			$"..".dir = -1
			print($"..".dir)
		elif GameUtils.posX > $"..".global_position.x:
			$"..".dir = 1
			print($"..".dir)
	elif tempos > tempos2:
		if GameUtils.posXP2 < $"..".global_position.x:
			$"..".dir = -1
			print($"..".dir)
		elif GameUtils.posXP2 > $"..".global_position.x:
			$"..".dir = 1
			print($"..".dir)
