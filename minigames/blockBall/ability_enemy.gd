extends AnimatedSprite2D
@onready var main = $"../../.."
@export var enemyval = 1
@export var moveX = true
var abilitylist = [1, 2, 5, 4]
@onready var sfx = preload("res://kirbySprites/sfx/ability-gain.wav")
func _ready():
	play(str(enemyval))

func _on_area_2d_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("ball1"):
		GameUtils.ABILITY = abilitylist[enemyval-1]
		defeat()
	if body.is_in_group("ball2"):
		GameUtils.ABILITYP2 = abilitylist[enemyval-1]
		defeat()

func defeat():
	main.updateUI()
	$Area2D/CollisionShape2D.call_deferred("set","disabled",true)
	Sfxhandler.play_sfx(sfx,main)
	play("death")
	await animation_finished
	queue_free()
