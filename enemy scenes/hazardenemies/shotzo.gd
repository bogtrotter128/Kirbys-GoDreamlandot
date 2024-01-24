extends CharacterBody2D

@export var gravity = true
@export var candetect = true
@export var setangle = 0
@export var setani = 0

func _ready():
	if setangle > 0:
		$Marker2D.rotation_degrees = setangle
	if setani > 0 && setani < 6:
		$AnimatedSprite2D.play(str(setani))

func _process(_delta):
	animationswitcher()

func _physics_process(_delta):
	if gravity == true:
		velocity.y = move_toward(velocity.y, 200, 7)
		move_and_slide()

func _on_updatetimer_timeout():
	if tempvar != aninum:
		canupdate = true
var canupdate = false
var aninum = 1
var tempvar = 0
func animationswitcher():
	if canupdate == true:
		if tempvar > aninum:
			tempvar -= 1
		elif tempvar < aninum:
			tempvar += 1
		canupdate = false
		$AnimatedSprite2D.play(str(tempvar))

func bodyup(rot,anin):
	aninum = anin
	await get_tree().create_timer(0.12).timeout
	$Marker2D.rotation_degrees = rot

func _on__body_entered(body):
	if body.is_in_group("player") && candetect == true:
		bodyup(180,1)

func _on_b_body_entered(body):
	if body.is_in_group("player") && candetect == true:
		bodyup(-135,2)

func _on_c_body_entered(body):
	if body.is_in_group("player") && candetect == true:
		bodyup(-90,3)

func _on_d_body_entered(body):
	if body.is_in_group("player") && candetect == true:
		bodyup(-45,4)

func _on_e_body_entered(body):
	if body.is_in_group("player") && candetect == true:
		bodyup(0,5)


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.start()
func _on_visible_on_screen_notifier_2d_screen_exited():
	$Timer.stop()

@export var bullet : PackedScene

func _on_timer_timeout():
	var bull
	bull = bullet.instantiate()
	owner.add_sibling(bull)
	bull.transform = $Marker2D.global_transform
