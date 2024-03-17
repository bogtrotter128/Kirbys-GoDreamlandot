extends StaticBody2D

@onready var main = $"../../.."
@onready var sfx = {
	"hit" : preload("res://kirbySprites/sfx/block-destroy.wav"),
}

func breakblock(_damage,_damtype):
	Sfxhandler.play_sfx(sfx["hit"],main)
	destroyed()

func destroyed():
	$CollisionShape2D.call_deferred("set","disabled", true)
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()

func get_width():
	return $CollisionShape2D.shape.get_rect().size.x
