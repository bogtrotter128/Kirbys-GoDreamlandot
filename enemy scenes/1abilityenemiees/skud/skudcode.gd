extends Node

@export var rocket : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".copyAbilityScore = 9

func _process(_delta):
	if $"..".position.x == GameUtils.posX or $"..".position.x == GameUtils.posXP2:
		transform()

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		transform()
#summons the rocket
func transform():
	$"../AnimatedSprite2D".play("transform")
	await $"../AnimatedSprite2D".animation_finished
	var rockt = rocket.instantiate()
	owner.add_sibling(rockt)
	rockt.transform = $"..".global_transform
	$"..".queue_free()
