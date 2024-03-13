extends Node2D
var score = 0
var time = 0.0
var minutes = 0
var seconds = 0
var msec = 0

func _process(delta):
	time += delta
	msec = int((fmod(time, 1) * 1000) * 1)
	seconds = int(fmod(time, 60))
	minutes = int(fmod(time,3600) / 60)
	updateclock()

func updateclock():
	@warning_ignore("integer_division")
	var mins = [int((minutes/10)%10),int(minutes%10)]
	@warning_ignore("integer_division")
	var secs = [int((seconds/10)%10),int(seconds%10)]
	@warning_ignore("integer_division")
	var msecs = [int((msec/100)%10),int((msec/10)%10),int(msec%10)]
	for i in $CanvasLayer/minutes.get_child_count():
		$CanvasLayer/minutes.get_child(i).frame = mins[i]
	for i in $CanvasLayer/sec.get_child_count():
		$CanvasLayer/sec.get_child(i).frame = secs[i]
	for i in $CanvasLayer/msec.get_child_count():
		$CanvasLayer/msec.get_child(i).frame = msecs[i]

func updatescore(num):
	if score < 99999:
		score = num
		var scores = [int((score/100000)%10),int((score/10000)%10),int((score/1000)%10),int((score/100)%10),int((score/10)%10),int(score%10)]
		for i in $CanvasLayer/score.get_child_count():
			$CanvasLayer/score.get_child(i).frame = scores[i] if scores[i] >= 0 else 0
	else:
		for i in $CanvasLayer/score.get_child_count():
			$CanvasLayer/score.get_child(i).frame = 9
