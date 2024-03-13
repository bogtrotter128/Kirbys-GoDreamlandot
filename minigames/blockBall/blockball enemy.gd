extends AnimatedSprite2D
@onready var main = $"../../.."
@export var enemyval = 1
@export var enemydrop = 0
@export var moveX = false
@export var moveY = false

@onready var dropitem = preload("res://minigames/blockBall/item.tscn")

@onready var sfx = preload("res://kirbySprites/sfx/star-hit.wav")
func _ready():
	play(str(enemyval))

func _on_area_2d_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("ball"):
		defeat()

func defeat():
	Sfxhandler.play_sfx(sfx,main)
	$Area2D/CollisionShape2D.call_deferred("set","disabled",true)
	var drop = dropitem.instantiate()
	play("death")
	await animation_finished
	drop.position = position
	drop.itemval = enemydrop
	add_sibling(drop)
	queue_free()
