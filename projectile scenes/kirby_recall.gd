extends Area2D

@export var KirbySpawn : PackedScene

func _process(_delta):
	GameUtils.posX = global_position.x
	GameUtils.posY = global_position.y

func _physics_process(_delta):
	$".".global_position.x = move_toward($".".global_position.x, GameUtils.posXP2, 3)
	$".".global_position.y = move_toward($".".global_position.y, GameUtils.posYP2 - 5, 1.4)
	
	if $".".global_position.x > GameUtils.posXP2:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
	if body.is_in_group("player2"):
		summon()

func summon():
	var summonkirb
	summonkirb = KirbySpawn.instantiate()
	
	summonkirb.position.x = $".".global_position.x + (-5 * GameUtils.DIRP2)
	summonkirb.position.y = $".".global_position.y + (-5 * GameUtils.DIRP2)
	call_deferred("add_sibling",summonkirb)
	$".".queue_free()
