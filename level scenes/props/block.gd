extends StaticBody2D

@export var blocktype = 0
var copyAbilityScore = 0

var spritelist = [
	preload("res://kirbySprites/props/blocks/powblock.png"),
	preload("res://kirbySprites/props/blocks/powblock dark.png"),
]
func _ready():
	updatetexture()

func updatetexture():
	$Sprite2D.texture = spritelist[blocktype]

func blockbreak():
	$CollisionShape2D.call_deferred("set","disabled",true)
	$Sprite2D.hide()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func disablecollision():
	$CollisionShape2D.call_deferred("set","one_way_collision",true)
	await get_tree().create_timer(0.5).timeout
	blockbreak()
