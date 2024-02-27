extends Area2D

@export var KirbySpawn : PackedScene
var candrop = true
func _ready():
	$ballfriend.play(str(GameUtils.FRENVAL))

func _process(_delta):
	GameUtils.posX = global_position.x
	GameUtils.posY = global_position.y

func _physics_process(_delta):
	$".".global_position.x = move_toward($".".global_position.x,GameUtils.posXP2, 4)
	$".".global_position.y = move_toward($".".global_position.y,GameUtils.posYP2 -1,3)
	if $".".global_position.x > GameUtils.posXP2:
		$AnimatedSprite2D.flip_h = true
		$ballfriend.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		$ballfriend.flip_h = false
func _on_body_entered(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		candrop = false
		$playerdetect/CollisionShape2D.call_deferred("set","disabled",true)
func _on_body_exited(body):
	if body.name == "maintiles" or body.is_in_group("powblock"):
		candrop = true
		$playerdetect/CollisionShape2D.call_deferred("set","disabled",false)
func _on_playerdetect_body_entered(body):
	if body.is_in_group("player2") && candrop == true:
		summon()
func _on_playerdetect_area_entered(area):
	if area.is_in_group("player2") && candrop == true:
		summon()

func summon():
	candrop = false
	var summonkirb
	summonkirb = KirbySpawn.instantiate()
	summonkirb.position.x = $".".global_position.x + (-5 * GameUtils.DIRP2)
	summonkirb.position.y = $".".global_position.y
	call_deferred("add_sibling",summonkirb)
	$".".queue_free()
