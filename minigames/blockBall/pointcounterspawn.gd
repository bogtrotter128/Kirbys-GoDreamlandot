extends Node2D

var score = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	updatescore(score)
	await get_tree().create_timer(0.2).timeout
	var tween = get_tree().create_tween()
	var tween1 = get_tree().create_tween()
	tween.tween_property(self, "position", position - Vector2(0,25), 0.3)
	tween1.tween_property(self, "modulate:a", 0, 0.3)
	tween.tween_callback(queue_free)

func updatescore(num):
	if score < 99999:
		score = num
		var scores = [int(score%10),int((score/10)%10),int((score/100)%10),int((score/1000)%10),int((score/10000)%10),int((score/100000)%10)]
		for i in len(str(score)):
			self.get_child(i).frame = scores[i] if scores[i] >= 0 else 0
	else:
		for i in self.get_child_count():
			self.get_child(i).frame = 9

