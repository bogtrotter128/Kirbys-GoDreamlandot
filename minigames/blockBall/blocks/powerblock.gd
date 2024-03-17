extends StaticBody2D
@export var blockpoints = 500
@onready var main = $"../../.."

@onready var sfx = {
	"hit" : preload("res://kirbySprites/sfx/star-bounce.wav"),
	"break" : preload("res://kirbySprites/sfx/thud.wav")
}

func _ready():
	$AnimatedSprite2D.play("default")

func breakblock(_damage,damtype):
	if damtype == "powered":
		main.pointspawn(blockpoints,self.position)
		destroyed()
		Sfxhandler.play_sfx(sfx["break"],main)
	else:
		$AnimatedSprite2D.play("default")
		Sfxhandler.play_sfx(sfx["hit"],main)

func update(val):
	$Sprite2D.frame = val

func destroyed():
	$CollisionShape2D.call_deferred("set","disabled", true)
	$AnimatedSprite2D.play("poof")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()

func get_width():
	return $CollisionShape2D.shape.get_rect().size.x
