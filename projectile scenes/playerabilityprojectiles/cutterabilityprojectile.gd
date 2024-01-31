extends Area2D

var turn = false
var catch = false
var up = false
var dir = 1
var diry = 1
var timeunscale
var inititaly = 0
func _ready():
	if Input.is_action_pressed("up") && GameUtils.ABILITY == 6:
		up = true
	if Input.is_action_pressed("P2up") && GameUtils.ABILITYP2 == 6:
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
		position += transform.y * (diry * (2 + timescale)) * delta
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
	if body.is_in_group("player") && catch == true:
		self.queue_free()

func _on_walldetect_body_entered(body):
	if body.name == "maintiles":
		turn = true
		catch = true
		$Timer.stop()
		timeunscale = true
		timescale = 0

var timescale = 1

func _on_timer_timeout():
	if timescale < 90:
		timescale += 6 + timescale
	if timescale >= 90:
		$Timer.stop()
		timeunscale = true
