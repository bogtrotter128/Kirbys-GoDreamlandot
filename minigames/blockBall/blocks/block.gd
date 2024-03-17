extends StaticBody2D
@export var blockval = 3
@export var blockpoints = [100,200,500]
@onready var main = $"../../.."
var bubbled = false
@onready var sfx = {
	"hit" : preload("res://kirbySprites/sfx/menu-select.wav")
}

func _ready():
	$Sprite2D.frame += blockval -1
	main.blockgoal += 1

func breakblock(damage,_damtype):
	main.pointspawn(blockpoints[blockval-1],self.position)
	Sfxhandler.play_sfx(sfx["hit"],main)
	if blockval > 0:
		blockval -= damage
		blockval = 0 if blockval < 0 else blockval
		if blockval == 0:
			destroyed()
	update($Sprite2D.frame - 1)
func bubble():
	bubbled = true
	blockval = 0
	update(blockval)

func update(val):
	$Sprite2D.frame = val

func destroyed():
	main.blockcount += 1
	print(main.blockcount)
	$CollisionShape2D.call_deferred("set","disabled", true)
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("default")
	if bubbled == true:
		main.bonusscore += 1
	await $AnimatedSprite2D.animation_finished
	self.queue_free()

func get_width():
	return $CollisionShape2D.shape.get_rect().size.x
