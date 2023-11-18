extends StaticBody2D
var cancheck = false

func _input(_event):
	if Input.is_action_just_pressed("down") && cancheck == true:
		await get_tree().create_timer(0.1).timeout
		$CollisionShape2D.set_deferred("disabled", true)


func _on_area_2d_body_entered(body):
	if body.name == "player":
		cancheck = true

func _on_area_2d_body_exited(body):
	if body.name == "player":
		$CollisionShape2D.set_deferred("disabled", false)
		cancheck = false
