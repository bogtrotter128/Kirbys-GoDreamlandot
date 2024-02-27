extends Node
@export var rocket : PackedScene
var blastoff = true
func _ready():
	$"..".copyAbilityScore = 9
var shoot = false
func _physics_process(_delta):
	if $"..".position.x == GameUtils.posX or $"..".position.x == GameUtils.posXP2:
		transform()
	if shoot == true:
		$"..".velocity.x=0

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		shoot = true
		transform()
#summons the rocket
func transform():
	if blastoff == true:
		blastoff = false
		$"../AnimatedSprite2D".play("transform")
		await $"../AnimatedSprite2D".animation_finished
		var rockt = rocket.instantiate()
		owner.add_sibling(rockt)
		rockt.transform = $"..".global_transform
		$"..".queue_free()
