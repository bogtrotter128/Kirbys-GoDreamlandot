extends Node2D
@onready var main = $"../../.."
var points = [1000,1500,2000]
var timescore = 2.0
var itemval = 0
#0-apple
#1-candy
#2-cake

#3-crash
#4-changer
#5-flip
#6-doubleball

@onready var sfx = preload("res://kirbySprites/sfx/health.wav")

func _ready():
	$itemsprite.play(str(itemval))
	await get_tree().create_timer(3).timeout
	$Timer.start()

func collected():
	Sfxhandler.play_sfx(sfx,main)
	if itemval < 3:
		$Area2D/CollisionShape2D.call_deferred("set","disabled",true)
		main.pointspawn(points[itemval],self.position)
		await get_tree().create_timer(0.1).timeout
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0,25), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		tween.tween_callback(queue_free)
	else:
		$Area2D/CollisionShape2D.call_deferred("set","disabled",true)
		main.specialitem(itemval)
		await get_tree().create_timer(0.1).timeouts
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0,25), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		tween.tween_callback(queue_free)

func _on_area_2d_body_entered(body):
	if body.is_in_group("ball"):
		collected()

func _on_timer_timeout():
	flash()
	timescore -= 0.1
	if timescore <= 0:
		queue_free()
	else:
		$Timer.set_wait_time(timescore)

func flash():
	$itemsprite.hide()
	await get_tree().create_timer(0.1).timeout
	$itemsprite.show()
