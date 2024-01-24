extends StaticBody2D
var cancheck1 = false
var cancheck2 = false

func _input(_event):
	if Input.is_action_just_pressed("down") && cancheck1 == true:
		fall()
		cancheck1 = false
	if Input.is_action_just_pressed("P2down") && cancheck2 == true:
		fall()
		cancheck2 = false

func fall():
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.set_deferred("disabled", false)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player1"):
		cancheck1 = true
	if body.is_in_group("player2"):
		cancheck2 = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player1"):
		cancheck1 = false
	if body.is_in_group("player2"):
		cancheck2 = false
