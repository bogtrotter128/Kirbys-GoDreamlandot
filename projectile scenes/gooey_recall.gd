extends Area2D

@export var GooeySpawn : PackedScene

func _physics_process(_delta):
	$".".global_position.x = move_toward($".".global_position.x, GameUtils.posX, 1.6)
	$".".global_position.y = move_toward($".".global_position.y, GameUtils.posY - 5, 2)
	
	if $".".global_position.x > GameUtils.posX:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
#	&& global_position.y <= GameUtils.posY
	if body.name == "Player1":
		summon()

func summon():
	var summongoo
	summongoo = GooeySpawn.instantiate()
	
	summongoo.position.x = $".".global_position.x + (-5 * GameUtils.DIR)
	summongoo.position.y = $".".global_position.y + (-5 * GameUtils.DIR)
	call_deferred("add_sibling",summongoo)
	$".".queue_free()
