extends StaticBody2D

@export var blocktype = 0
var blockpoofer = preload("res://level scenes/props/poofblockpoofer.tscn")
var spritelist = [
	preload("res://kirbySprites/props/blocks/poofblock.png"),
	preload("res://kirbySprites/props/blocks/powblock dark.png"),
]
func _ready():
	updatetexture()

func updatetexture():
	$Sprite2D.texture = spritelist[blocktype]

func blockpoof():
	$CollisionShape2D.call_deferred("set","disabled",true)
	$Sprite2D.hide()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	summonpoofer()
	await $AnimatedSprite2D.animation_finished
	queue_free()

func summonpoofer():
	await get_tree().create_timer(0.2).timeout
	var poofer = blockpoofer.instantiate()
	call_deferred("add_sibling", poofer)
	poofer.global_transform = global_transform

func blockbreak(): #function is used for powblock break checks. which should do nothing
	pass
