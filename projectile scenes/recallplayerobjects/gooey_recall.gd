extends Area2D

@export var GooeySpawn : PackedScene

func _process(_delta):
	GameUtils.posXP2 = global_position.x
	GameUtils.posYP2 = global_position.y

func _physics_process(_delta):
	$".".global_position.x = move_toward($".".global_position.x, GameUtils.posX, 3)
	$".".global_position.y = move_toward($".".global_position.y, GameUtils.posY - 5, 1.4)
	
	if $".".global_position.x > GameUtils.posX:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
	if body.is_in_group("player1"):
		summon()
func _on_area_entered(area):
	if area.is_in_group("player1"):
		summon()
func summon():
	var summongoo
	summongoo = GooeySpawn.instantiate()
	
	summongoo.position.x = $".".global_position.x
	summongoo.position.y = $".".global_position.y -5
	call_deferred("add_sibling",summongoo)
	$".".queue_free()
