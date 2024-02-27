extends Area2D

var turn = false
var catch = false
var up = false
var dir = 1
var diry = 1
var timeunscale
var inititaly = 0
var group = ""
func _ready():
	if is_in_group("player1"):
		group = "player1"
	if is_in_group("player2"):
		group = "player2"
	if Input.is_action_pressed("up") && is_in_group("player1"):
		up = true
	if Input.is_action_pressed("P2up") && is_in_group("player2"):
		up = true
	await get_tree().create_timer(0.8).timeout
	turn = true
	catch = true
func _process(delta):
	if inititaly == 0:
		getinitialy()
	if global_position.y > inititaly:
		diry = -1
	if turn == true:
		turn = false
		dir = dir * -1
	if up == true:
		position += transform.y * (diry * (2.0 + timescale)) * delta
	position += transform.x * (140 * dir) * delta
	if timeunscale == true:
		timescale = move_toward(timescale,0,4)

func getinitialy():
	inititaly = global_position.y
	print(inititaly)

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage(3)
		self.queue_free()
	if body.is_in_group("powblock"):
		body.blockbreak()
		self.queue_free()
	if body.is_in_group(group) && catch == true:
		self.queue_free()

var timescale = 1.0

func _on_timer_timeout():
	if timescale < 90.0:
		timescale += 8.0 + timescale
	if timescale >= 90.0:
		timescale -= 1.0
#		$Timer.stop()
#		timeunscale = true
