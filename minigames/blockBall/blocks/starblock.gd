extends StaticBody2D

var blockval = 0
@export var sprite_hidden = true
var blockpoints = [50,100,200,400,800,1600]
@onready var main = $"../../.."
@onready var sfx = {
	"appear" : preload("res://kirbySprites/sfx/star-hit.wav"),
	"hit" : preload("res://kirbySprites/sfx/menu-select.wav")
}
func _ready():
	$AnimatedSprite2D.visible = true if sprite_hidden == false else false

func breakblock(_damage,_damtype):
	if sprite_hidden == true:
		sprite_hidden = false
		appear()
	else:
		main.pointspawn(blockpoints[blockval],self.position)
		blockval += 1
		Sfxhandler.play_sfx(sfx["hit"],main)
		if blockval > 5:
			destroyed()

func destroyed():
	$CollisionShape2D.call_deferred("set","disabled", true)
	$AnimatedSprite2D.play("appear")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
func appear():
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("appear")
	Sfxhandler.play_sfx(sfx["appear"],main)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")

func get_width():
	return $CollisionShape2D.shape.get_rect().size.x
