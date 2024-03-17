extends StaticBody2D
@onready var main = $"../../.."
@onready var sfx = {
	"catch" : preload("res://kirbySprites/sfx/swim.wav")
}
var bump = false
func catch():
	if bump == false:
		bump = true
		$AnimatedSprite2D.play("bump")
		Sfxhandler.play_sfx(sfx["catch"],main)
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("default")
		bump = false
	
func get_width():
	return $CollisionShape2D.shape.get_rect().size.x
